screenLabel = "Ore" --export : label for top of screen
threshold = 10000   --export : line turns red when less than this
debug = false

core = null
screen = null

function log(msg)
  if debug then
    system.print(msg)
  end
end

function startup()
  log("search for core and screen")
  local valid = true
  for linkName, element in pairs(library.getLinks()) do
    local cls = element.getClass()
    if element.setRenderScript then
      screen = element
    end
    if element.getElementNameById then
      core = element
    end
    log(string.format('Found link `%s` of type `%s`', linkName, cls))
  end

  if core == null then
    system.print("ERR: Core link not found")
    valid = false
  end
  if screen == null then
    system.print("ERR: Screen link not found")
    valid = false
  end

  if not valid then
    system.print("------------------------")
    system.print("Required Links not found")
    system.print("link to the core")
    system.print("link to ONE screen")
    system.print("link up to 8 containers")
    system.print("------------------------")
    system.print("links can be in any order")
    unit.exit()
    return
  end

  links = {}
  log("search for containers")
  for _, element in pairs(library.getLinks()) do
    if element.getClass then
      local cls = element.getClass()
      log(cls)
      if string.find(cls, "Container") then
        local id = element.getLocalId()
        local name = string.lower(core.getElementNameById(id))
        links[#links+1] = { value=element, name=name, vol=-1}
      end
    end
  end
  if #links == 0 then
    system.print("Cannot find any container links")
    unit.exit()
  end

  table.sort(links, function(a,b) return a.name < b.name end)
  unit.setTimer("monitor", 5)
  if debug == false then
    unit.hideWidget()
  end

  unit:onEvent("onTimer", function (self, timerId)
    if timerId == "monitor" then
      monitor()
    end
  end)

  local renderScript = library.embedFile("screen.lua")
  renderScript = 'local screenTitle="' .. screenLabel .. '"\n' .. renderScript
  screen.setRenderScript(renderScript)
  screen.activate()
end

function formatComma(num)
  return formatStr(num.."")
end

function formatStr(val)
  if string.len(val) <= 3 then
    return val
  end

  right = string.sub(val, string.len(val)-2)
  left = string.sub(val, 0,string.len(val)-3)
  return formatComma(left) ..","..right
end

function reportLine(rec)
  local amtInt = math.floor(rec.vol)
  local amount = formatComma(amtInt)
  local label = rec.name:gsub("^%l", string.upper)
  local flag = "0"
  if (amtInt < threshold) then
    flag = "1"
  end
  return label.."#"..amount.."#"..flag
end

function monitor()
  local payload = ""
  for _, rec in pairs(links) do
    local vol = rec.value.getItemsVolume()
    if vol == null then
      system.print("out of range, stopping")
      unit.exit()
      return
    end
    log("monitor "..rec.name.." v:"..vol)
    rec.vol = vol
    local line = reportLine(rec)
    payload = payload .. line .. "$"
  end
  screen.setScriptInput(payload)
end

startup()
monitor()
