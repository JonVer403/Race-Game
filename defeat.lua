local composer = require( "composer" )
 
local scene = composer.newScene()
local json = require("json")

local filePath = system.pathForFile("scores.json", system.DocumentsDirectory)

local score = composer.getVariable("finalScore")

local function gotomenu()
	composer.removeScene( "menu" )
	composer.gotoScene( "menu" )
end

function scene:create( event )
    local sceneGroup = self.view

	local menuButton = display.newText(sceneGroup, "Menu", display.contentCenterX, 20, native.systemFont, 30)
	local scoreText = display.newText(sceneGroup, "Your Score: " .. score, display.contentCenterX, display.contentCenterY, native.systemFont, 40)

    sceneGroup:insert(scoreText)
    sceneGroup:insert(menuButton)

	menuButton:addEventListener("tap", gotomenu)
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
