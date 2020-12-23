screenLabel = "Ore" --export : label for top of screen
fontsize = 10       --export : higher font, less lines
threshold = 10000   --export : line turns red when less than this

indexes = {}
typeWeights = {
-- T1
  coal = 1.35,
  quartz = 2.65,
  hematite = 5.04,
  bauxite = 1.28,

  carbon = 2.27,
  silicon = 1.0,
  iron = 1.0,
  aluminum = 1.0,
-- T2
  malachite = 4.0,
  natron = 1.55,
  limestone = 2.71,
  chromite = 4.54,

  copper = 8.96,
  sodium = 0.97,
  calcium = 1.55,
  chromium = 1.0,
-- T3
  garnierite = 2.60,
  petalite = 2.41,
  pyrite = 5.01,
  acanthite = 7.20,

  nickel = 8.91,
  lithium = 0.53,
  sulfur = 1.82,
  silver = 10.49
-- T4
  cryolite = 2.95

  fluorine = 1.70

}
typeWeights["warp cell"] = 100
typeWeights["al fe alloy"] = 7.5
typeWeights["calcium copper"] = 8.10
typeWeights["cu ag alloy"] = 9.20
typeWeights["aileron m"] = 3140
typeWeights["atmospheric airbrake m"] = 285.25
typeWeights["basic space engine m"] = 4090
typeWeights["medium adjustor"] = 220.38
typeWeights["medium atmo engine"] = 2980
typeWeights["stabilizer m"] = 2030
typeWeights["wing m"] = 1700
typeWeights["wing variant m"] = 1700

function unrequire(m)
    package.loaded[m] = nil
    _G[m] = nil
end
unrequire'json'
unrequire'Navigator'
unrequire'Helpers'
unrequire'AxisCommand'
unrequire'database'
unrequire'cpml/sgui'
unrequire'pl/init'

core = null
screen = null

function findWeight(name)
    n=string.lower(name)
    for key,value in pairs(typeWeights) do
        found = string.find(name, key)
        if found ~= nil then
          return value
        end
    end
    return 1
end

function startup()
    for key, value in pairs(unit) do
        if type(value) == "table" and type(value.export) == "table" then
            if value.getElementClass then
                cls = value.getElementClass()
                if string.find(cls, "CoreUnit") then
                    core = value
                end
                if cls == "ScreenUnit" then
                    screen = value
                end
            end
        end
    end
    if core == null then
        system.print("ERR: Core link not found")
        unit.exit()
        return
    end
    if screen == null then
        system.print("ERR: Screen link not found")
        unit.exit()
        return
    end

    links = {}
    linkSize = 1
    for key, value in pairs(unit) do
        if type(value) == "table" and type(value.export) == "table" then
            if value.getElementClass then
                cls = value.getElementClass()
                if cls == 'ItemContainer' then
                    id = value.getId()
                    name = string.lower(core.getElementNameById(id))
                    weight = findWeight(name)
                    r = { value=value, name=name, mass=-1, weight=weight}
                    links[linkSize] = r
                    linkSize = linkSize + 1
                end
            end
        end
    end
    linkSize = linkSize - 1

    table.sort(links, function(a,b) return a.name < b.name end)
    unit.setTimer("Monitor", 5)
    unit.hide()
    screen.clear()
    screen.addContent(1, 0, "<div style=\"text-align: center; font-face:Arial;font-size: "..fontsize.."vh; border-bottom: 3px solid white; width: 100vw\">"..screenLabel.."</div>")
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

function getReportLine(labelStr, container, weight, mass)
    amtInt = math.floor(mass / weight)
    amount = formatComma(amtInt)
    color = ""
    if (amtInt < threshold) then
        color = "background-color: red"
    end
    label = labelStr:gsub("^%l", string.upper)
    labelDiv = "<div style=\"width: 65vw;text-align: left;\">"..label.."</div>"
    amountDiv ="<div style=\"width: 25vw;text-align: right;\">"..amount.." </div>"
    return "<div style=\"padding-left: 20px; font-family:Arial; font-size: "..(fontsize-1).."vh; display: flex; flex-direction: row;"..color.."\">"..labelDiv.." "..amountDiv.."</div>"
end


function monitor()
    for idx=1,linkSize do
        rec = links[idx]
        mass = rec.value.getItemsMass()
        if mass == null then
           system.print("out of range, stopping")
           unit.exit()
           return
        end
        if rec.mass ~= mass then
            rec.mass = mass
            line = getReportLine(rec.name, rec.value, rec.weight, mass)

            lineID = indexes[idx]
            if lineID == null then
                height = idx * (fontsize + 1)
                lineID = screen.addContent(1, height, line)
                indexes[idx] = lineID
            else
                screen.resetContent(lineID, line)
            end
        end
    end
end


startup()
monitor()
