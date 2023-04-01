function DrawGrid(header, rows, startX, startY, layer, font)
    local rowHeight = header.rowHeight or 30
    local currX = startX
    local currY = startY+rowHeight

    --header
    local columns = header.columns
    local skipHeader = header.skipHeader or false
    if not skipHeader then
        for cIdx=1,#columns do
            if columns[cIdx].title then
                if columns[cIdx].titleColor then
                    setNextFillColor(layer, columns[cIdx].titleColor[1], columns[cIdx].titleColor[2], columns[cIdx].titleColor[3], 1)
                else
                    setNextFillColor(layer, 1,1,1,1)
                end
                setNextTextAlign(layer, AlignH_Left, AlignV_Middle)
                addText(layer, font, columns[cIdx].title, currX, currY - (rowHeight/2))
            end
            currX = currX + columns[cIdx].width
        end
        setNextStrokeWidth(layer, 1)
        setNextStrokeColor(layer, 1,1,1,1)
        setNextFillColor(layer, 0,0,0,0)
        addBox(layer, startX, startY,currX-startX,rowHeight)
        currY = currY + rowHeight
    end

    --cols
    for rIdx=1,#rows do
        currX = startX
        local currRow = rows[rIdx]
        for cIdx=1,#columns do
            if columns[cIdx].type == "txt" then
                local alignH = AlignH_Left
                if columns[cIdx].align and columns[cIdx].align == "right" then
                    alignH = AlignH_Right
                end
                setNextTextAlign(layer, alignH, AlignV_Middle)
                if currRow.color then
                    setNextFillColor(layer, currRow.color[1],currRow.color[2],currRow.color[3], 1)
                else
                    if columns[cIdx].titleColor then
                        setNextFillColor(layer, columns[cIdx].titleColor[1], columns[cIdx].titleColor[2], columns[cIdx].titleColor[3], 1)
                    else
                        setNextFillColor(layer, 1,1,1,1)
                    end
                end
                if alignH == AlignH_Left then
                    addText(layer,font, currRow.data[cIdx],currX, currY-(rowHeight/2))
                else
                    if alignH == AlignH_Right then
                        addText(layer,font, currRow.data[cIdx],currX+ columns[cIdx].width, currY-(rowHeight/2))
                    end
                end
            end
            if columns[cIdx].type == "img" then
                addImage(layer, currRow.data[cIdx], currX, currY-(rowHeight*0.9), rowHeight*0.8,rowHeight*0.8)
            end
            currX=currX+ columns[cIdx].width
        end
        if header.dividers then
            setNextStrokeWidth(layer, 0.25)
            setNextStrokeColor(layer, 1,1,1,1)
            addLine(layer, startX,currY, currX,currY)
        end
        currY=currY+rowHeight
    end
end

function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local rx, ry = getResolution()
local vw = rx/100
local vh = ry/100
local layer = createLayer()
local font = loadFont("Play", vh*10)

if not _init then
    gridHeader = {
        skipHeader=true,
        columns={
            {width=vw*70, type="txt" },
            {width=vw*25, type="txt", align="right"}
        },
        rowHeight = vh * 11
    }
    _init = true
end

setNextTextAlign(layer, AlignH_Center, AlignV_Middle)
addText(layer, font, screenTitle, vw*50, vh*5)

setNextStrokeWidth(layer, 1.5)
setNextStrokeColor(layer, 1,1,1,1)
addLine(layer, 0,vh*10, rx,vh*10)

local payload = getInput()

local gridRows = {}
for idx, row in pairs(mysplit(payload, "$")) do
    logMessage("idx "..tostring(idx).." v "..tostring(row))
    local cols = mysplit(row, "#")
    local gridRow = {data=cols}
    if cols[3] == "1" then
        gridRow.color = {1,0,0}
    end
    gridRows[#gridRows+1] = gridRow
end
DrawGrid(gridHeader, gridRows, vh, vh*11, layer, font)