local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()

local score = 0
local lives = 3
local baseSpeed = 70
local baseTimeToSpawn = 5000
local enemyCars = {}

local image = display.newImageRect( "Background/Kunst.jpg",
               display.contentWidth, display.contentHeight) 
image.x = display.contentCenterX
image.y = display.contentCenterY

local liveText = display.newText( "Lives: " .. lives, display.contentCenterX, display.contentCenterY + 300, native.systemFont, 20 )
local userCar = display.newRect( display.contentCenterX, display.contentHeight - 50, 50, 100 )
local rightButton = display.newRect( display.contentWidth - 50, display.contentHeight - 50, 80, 80 )
local leftButton = display.newRect( 50, display.contentHeight - 50, 80, 80 )


function moveEnemyCar(event)
    local lanes = {display.contentWidth * 0.25, display.contentWidth * 0.5, display.contentWidth * 0.75}
    local laneIndex = math.random(1, 3)
    local enemyX = lanes[laneIndex]
    local enemyCar = display.newRect( enemyX, -50, 50, 80 )
    physics.addBody( enemyCar, "dynamic", { isSensor=true } )
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

local function onCollision(event)
    if event.phase == "began" then
        if lives > 1 then
            lives = lives - 1
            liveText.text = "Lives: " .. lives
        elseif lives == 1 then
            composer.gotoScene("defeat")
        end
    end
end



local function scoreUp(event)
    if event.phase == "began" then
        score = score + 1
        scoreText.text = "Score: " .. score
    end
end


function scene:create( event )
    local sceneGroup = self.view

    physics.start()
    physics.setGravity(0,0)

    physics.addBody( userCar, "dynamic", { isSensor=true } )
    physics.addBody( borderBottom, "static", { isSensor=true } )

    sceneGroup:insert( userCar )
    sceneGroup:insert( rightButton )
    sceneGroup:insert( leftButton )
    userCar:addEventListener( "collision", onCollision )
    borderBottom:addEventListener( "collision", scoreUp )
    sceneGroup:insert( liveText )
    sceneGroup:insert( scoreText )

    timer.performWithDelay(baseTimeToSpawn, function()
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