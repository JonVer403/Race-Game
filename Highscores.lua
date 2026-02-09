local composer = require( "composer" )
 
local scene = composer.newScene()
local json = require("json")
local scoresTable = {}

local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)

local function loadScores()
    local file = io.open(filePath, "r")
    if file then
        local contents = file:read("*a")
        io.close(file)
        scoresTable = json.decode(contents)
    end
    if scoresTable == nil or #scoresTable == 0 then
        scoresTable = {0,0,0,0,0,0,0,0}
    end
end

local function saveScores()
    for i = #scoresTable, 11, -1 do
        table.remove(scoresTable, i)
    end

    local file = io.open(filePath, "w")
    
    local temp = json.encode(scoresTable)

    file:write(temp)
    io.close(file)
end

local function gotomenu()
    composer.removeScene( "menu" )
    composer.gotoScene( "menu" )
end

function scene:create( event )
    local sceneGroup = self.view

    local menuButton = display.newText(sceneGroup, "Menu", display.contentCenterX, 20, native.systemFont, 30)
    menuButton:addEventListener("tap", gotomenu)

    loadScores()

    table.insert(scoresTable, composer.getVariable("finallScore"))

    local function compare(a, b)
        return a > b
    end

    table.sort(scoresTable, compare)

    saveScores()

    local highScoreHeader = display.newText(sceneGroup, "High Scores", display.contentCenterX, 50, native.systemFont, 40)
    
    for i = 1, 10 do
        if (scoresTable[i]) then
            local yPos = 70 + (i * 56)

            local rankNum = display.newText(sceneGroup, i .. ") ", display.contentCenterX - 50, yPos, native.systemFont, 20)
            rankNum:setFillColor(0.8)
            rankNum.anchorX = 1

            local thisScore = display.newText(sceneGroup, scoresTable[i], display.contentCenterX - 30, yPos, native.systemFont, 20)
            rankNum.anchorX = 1

        end
    end
end




function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
