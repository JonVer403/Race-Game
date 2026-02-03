local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()

local score = 0
local lives = 3
local baseSpeed = 70
local enemyCars = {}

local liveText = display.newText( "Lives: " .. lives, display.contentCenterX, 20, native.systemFont, 20 )
local userCar = display.newRect( display.contentCenterX, display.contentHeight - 50, 50, 100 )
local rightButton = display.newRect( display.contentWidth - 50, display.contentHeight - 50, 80, 80 )
local leftButton = display.newRect( 50, display.contentHeight - 50, 80, 80 )


function moveEnemyCar(event)
    local lanes = {display.contentWidth * 0.25, display.contentWidth * 0.5, display.contentWidth * 0.75}
    local laneIndex = math.random(1, 3)
    local enemyX = lanes[laneIndex]
    local enemyCar = display.newRect( enemyX, -50, 50, 100 )
    physics.addBody( enemyCar, "dynamic")
    enemyCar:setLinearVelocity(0, baseSpeed)
    table.insert(enemyCars, enemyCar)
    return enemyCar
end

function moveUserCarRight(event)
    if userCar.x == display.contentWidth * 0.25 then
        userCar.x = display.contentWidth * 0.5
    elseif userCar.x == display.contentWidth * 0.5 then
        userCar.x = display.contentWidth * 0.75
    end
end

function moveUserCarLeft(event)
    if userCar.x == display.contentWidth * 0.75 then
        userCar.x = display.contentWidth * 0.5
    elseif userCar.x == display.contentWidth * 0.5 then
        userCar.x = display.contentWidth * 0.25
    end
end

function collisionListener( self, event )
    if ( event.phase == "began" ) then
        if ( event.other == enemyCar ) then
            lives = lives - 1
            liveText.text = "Lives: " .. lives
            if lives <= 0 then
                composer.gotoScene( "menu" )
            end
        end
    end
end

function scene:create( event )
    local sceneGroup = self.view

    physics.start()
    physics.setGravity(0,0)

    sceneGroup:insert( userCar )
    sceneGroup:insert( rightButton )
    sceneGroup:insert( leftButton )
    userCar.collision = collisionListener
    userCar:addEventListener( "collision" )
    sceneGroup:insert( liveText )

    timer.performWithDelay(5000, function()
        local newCar = moveEnemyCar()
        sceneGroup:insert(newCar)
    end, 0)

    rightButton:addEventListener("tap", moveUserCarRight)
    leftButton:addEventListener("tap", moveUserCarLeft)
end

function scene:destroy( event )
    local sceneGroup = self.view

end

-- Scene event function listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene