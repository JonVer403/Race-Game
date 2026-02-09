local composer = require( "composer" )
 
local scene = composer.newScene()
local json = require("json")

local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)

local score = composer.getVariable("finalScore")



local function gotomenu()
	composer.removeScene( "menu" )
	composer.gotoScene( "menu" )
end

local function gotohighscores()
    composer.removeScene( "Highscores" )
    composer.gotoScene( "Highscores" )
end

function scene:create( event )
    local sceneGroup = self.view

	local highscoreButton = display.newText(sceneGroup, "High Scores", display.contentCenterX, display.contentCenterY + 50, native.systemFont, 30)
	local menuButton = display.newText(sceneGroup, "Menu", display.contentCenterX, 20, native.systemFont, 30)
	local scoreText = display.newText(sceneGroup, "Your Score: " .. score, display.contentCenterX, display.contentCenterY, native.systemFont, 40)

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

	sceneGroup:insert(highscoreButton)
    sceneGroup:insert(scoreText)
    sceneGroup:insert(menuButton)

	menuButton:addEventListener("tap", gotomenu)
	highscoreButton:addEventListener("tap", gotohighscores)
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
