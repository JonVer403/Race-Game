local composer = require( "composer" )
local physics = require("physics")
local scene = composer.newScene()
local json = require("json")

local filePath = system.pathForFile("highscore.json", system.DocumentsDirectory)

local score = 0
local lives = 3
local baseSpeed = 70
local Speed = baseSpeed
local baseTimeToSpawn = 5000
local enemySpawnTime = baseTimeToSpawn
local enemyCars = {}
local spawnTimer = nil


local borderBottom = display.newRect( display.contentCenterX, display.contentHeight + 200, display.contentWidth, 20 )
local scoreText = display.newText( "Score: " .. score, display.contentCenterX, 50, native.systemFont, 20 )
local liveText = display.newText( "Lives: " .. lives, display.contentCenterX, display.contentCenterY + 300, native.systemFont, 20 )
local userCar = display.newRect( display.contentCenterX, display.contentHeight - 50, 50, 100 )
local rightButton = display.newRect( display.contentWidth - 50, display.contentHeight - 50, 80, 80 )
local leftButton = display.newRect( 50, display.contentHeight - 50, 80, 80 )


function moveEnemyCar()
    local lanes = {display.contentWidth * 0.25, display.contentWidth * 0.5, display.contentWidth * 0.75}
    local laneIndex = math.random(1, 3)
    local enemyX = lanes[laneIndex]

    local enemyCar = display.newRect(enemyX, -50, 50, 80)
    physics.addBody(enemyCar, "dynamic", { isSensor=true })
    enemyCar:setLinearVelocity(0, Speed)

    table.insert(enemyCars, enemyCar)
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

    if (event.phase == "began") then

        if lives > 1 then
            lives = lives - 1
            liveText.text = "Lives: " .. lives
        elseif lives == 1 then
            composer.gotoScene("defeat")
        end

        if event.other then
            for i = #enemyCars, 1, -1 do
                if (event.other == enemyCars[i]) then
                    display.remove(enemyCars[i])
                    table.remove(enemyCars, i)
                    return
                end
            end
        end
        
    end
end



local function scoreUp(event)
    if event.phase == "began" then
        score = score + 1
        scoreText.text = "Score: " .. score
        if score < 60 then
            Speed = math.min(baseSpeed + (score * 8), 250)
            enemySpawnTime = math.max(1000, baseTimeToSpawn - (score * 400))
        else
            Speed = 300
            enemySpawnTime = 800
        end
        if spawnTimer then
            timer.cancel(spawnTimer)
        end

        spawnTimer = timer.performWithDelay(enemySpawnTime, moveEnemyCar, 0)

    end
end



function scene:create( event )
    local sceneGroup = self.view


    spawnTimer = timer.performWithDelay(enemySpawnTime, moveEnemyCar, 0)

    physics.start()
    physics.setGravity(0,0)

    physics.addBody( userCar, "dynamic", { isSensor=true } )
    physics.addBody( borderBottom, "static", { isSensor=true } )

    sceneGroup:insert( userCar )
    sceneGroup:insert( rightButton )
    sceneGroup:insert( leftButton )
    sceneGroup:insert( borderBottom )
    sceneGroup:insert( liveText )
    sceneGroup:insert( scoreText )

    userCar:addEventListener( "collision", onCollision )
    borderBottom:addEventListener( "collision", scoreUp )
    rightButton:addEventListener("tap", moveUserCarRight)
    leftButton:addEventListener("tap", moveUserCarLeft)
end

function scene:show( event )
    local phase = event.phase
    
    if ( phase == "will" ) then
        -- Reset variables
        score = 0
        lives = 3
        Speed = baseSpeed
        enemySpawnTime = baseTimeToSpawn
        scoreText.text = "Score: 0"
        liveText.text = "Lives: 3"
        
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- This runs when the scene is about to be removed (e.g., going to 'defeat')
        
        -- 1. Cancel the spawn timer
        if spawnTimer then
            timer.cancel(spawnTimer)
            spawnTimer = nil
        end
        
        -- 2. Optional: Stop the physics engine if you want to freeze everything
        -- physics.pause() 
    end
end

function scene:destroy( event )
    local sceneGroup = self.view
    if spawnTimer then
        timer.cancel(spawnTimer)
        spawnTimer = nil
    end
    physics.stop()

end

-- Scene event function listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene