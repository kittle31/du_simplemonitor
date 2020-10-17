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

function getReportLine(label, container, weight)
    amtInt = math.floor(container.getItemsMass() / weight)
    amount = formatComma(amtInt)
    color = "background-color: black"
    if (amtInt < 500) then
        color = "background-color: red"
    end
     labelDiv = "<div style=\"width: 50vw;text-align: left;\">"..label.."</div>"
     amountDiv ="<div style=\"width: 30vw;text-align: right;\">"..amount.." l</div>"
     --raw = math.floor(container.getItemsMass())
     --debug = "  <div style=\"width: 30vw;\">"..raw.."</div>"
     return "<div style=\"padding-left: 20px;font-size: 12vh; display: flex; flex-direction: row;"..color.."\">"..labelDiv.." "..amountDiv.."</div>"
end

function setReportLine(idx, scr, label, container, weight)
    line = getReportLine(label, container, weight)
    lineID = indexes[idx]
    if lineID == null then
        h = idx * 13
        lineID = scr.addContent(1, h, line)
        indexes[idx] = lineID
    else
        scr.resetContent(lineID, line)
    end
end

setReportLine(1,screen,"Iron", iron, 7.85)
setReportLine(2,screen,"Carbon", carbon, 2.27)
setReportLine(3,screen,"Silicon", silicon, 2.33)
setReportLine(4,screen,"Aluminum", aluminum, 2.70)
setReportLine(5,screen,"Calcium", calcium, 1.55)
setReportLine(6,screen,"Chromium", chromium, 7.19)


