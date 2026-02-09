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
    composer.setVariable("finalScore", 0)
    composer.removeScene( "menu" )
    composer.gotoScene( "menu" )
end

local function resetScore()
    scoresTable = {0,0,0,0,0,0,0,0,0,0}
    saveScores()
    composer.setVariable("finalScore", 0)
    composer.removeScene( "Highscores" )
    composer.gotoScene( "Highscores" )
end

function scene:create( event )
    local sceneGroup = self.view

    laneLinesL = display.newRect(sceneGroup, display.contentWidth * 0.15, display.contentCenterY, 5, 3000)
    laneLinesL:setFillColor(255, 191, 0)
    laneLinesR = display.newRect(sceneGroup, display.contentWidth * 0.85, display.contentCenterY, 5, 3000)
    laneLinesR:setFillColor(255, 191, 0)

    laneLinesMR = display.newRect(sceneGroup, display.contentWidth * 0.625, display.contentCenterY, 2, 3000)
    laneLinesML = display.newRect(sceneGroup, display.contentWidth * 0.375, display.contentCenterY, 2, 3000)
    
    GreeneryR = display.newRect(sceneGroup, display.contentWidth, display.contentCenterY, 80, 3000)
    GreeneryR:setFillColor(0.2, 0.8, 0.2)
    GreeneryL = display.newRect(sceneGroup, 0, display.contentCenterY, 80, 3000)
    GreeneryL:setFillColor(0.2, 0.8, 0.2)

    local resetButton = display.newText(sceneGroup, "Reset Scores", display.contentCenterX, display.contentHeight + 20, native.systemFont, 30)
    resetButton:addEventListener("tap", resetScore)
    resetButton:setFillColor(1, 0, 0)

    local menuButton = display.newText(sceneGroup, "Menu", display.contentCenterX, 0, native.systemFont, 30)
    menuButton:addEventListener("tap", gotomenu)

    loadScores()

    table.insert(scoresTable, composer.getVariable("finalScore"))

    local function compare(a, b)
        return a > b
    end

    table.sort(scoresTable, compare)

    saveScores()

    local highScoreHeader = display.newText(sceneGroup, "High Scores", display.contentCenterX, 50, native.systemFont, 40)
    highScoreHeader:setFillColor(0,0,1)


    for i = 1, 10 do
        if (scoresTable[i]) then
            local yPos = 70 + (i * 40)

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
