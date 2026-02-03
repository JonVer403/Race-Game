local composer = require( "composer" )
 
local scene = composer.newScene()


local function gotogame()
    composer.removeScene( "game" )
    composer.gotoScene( "game" )
end



function scene:create( event )
    local sceneGroup = self.view

    local gamebutton = display.newText( sceneGroup, "Game", display.contentCenterX, display.contentCenterY - 66, native.systemFont, 30 )
	
    sceneGroup:insert( gamebutton )
	
    gamebutton:addEventListener( "tap", gotogame )
    
    

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
