local composer = require("composer")
local physics = require("physics")
local scene = composer.newScene()

-- GAME VARIABLES
local score = 0
local lives = 3
local baseSpeed = 100
local Speed = baseSpeed
local baseTimeToSpawn = 4000
local enemySpawnTime = baseTimeToSpawn

local enemyCars = {}
local spawnTimer = nil
local lastSpawn = 0 


local borderBottom, scoreText, liveText
local userCar, rightButton, leftButton


local function moveEnemyCar()
    local lanes = {
        display.contentWidth * 0.25,
        display.contentWidth * 0.5,
        display.contentWidth * 0.75
    }

    local laneIndex = math.random(1, 3)
    local enemyX = lanes[laneIndex]

    local enemyCar = display.newImageRect(scene.view, "Auto foto's/enemyCar.png", 58, 100)
    enemyCar.x = enemyX
    enemyCar.y = -50
    physics.addBody(enemyCar, "dynamic", { isSensor = true })
    enemyCar:setLinearVelocity(0, Speed)

    table.insert(enemyCars, enemyCar)
    scene.view:insert(enemyCar)
end


local function moveUserCarRight()
    if userCar.x == display.contentWidth * 0.25 then
        userCar.x = display.contentWidth * 0.5
    elseif userCar.x == display.contentWidth * 0.5 then
        userCar.x = display.contentWidth * 0.75
    end
end

local function moveUserCarLeft()
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
        else
            composer.setVariable("finalScore", score)
            composer.removeScene("defeat")
            composer.gotoScene("defeat")
        end

        
        if event.other then
            for i = #enemyCars, 1, -1 do
                if event.other == enemyCars[i] then
                    display.remove(enemyCars[i])
                    table.remove(enemyCars, i)
                    break
                end
            end
        end
    end
end


local function scoreUp(event)
    if event.phase == "began" then
        score = score + 1
        scoreText.text = "Score: " .. score

       
        if score < 40 then
            Speed = math.min(baseSpeed + (score * 8), 230)
            enemySpawnTime = math.max(1000, baseTimeToSpawn - (score * 200))
        elseif score < 100 and score >= 40 then
            Speed = 350
            enemySpawnTime = 700
        elseif score < 150 and score >= 100 then
            Speed = 430
            enemySpawnTime = 500
        elseif score >= 150 then
            Speed = 550
            enemySpawnTime = 300
        end
    end
end

local function gotomenu()
    composer.removeScene("menu")
    composer.gotoScene("menu")
end



function scene:create(event)
    local sceneGroup = self.view

    physics.start()
    physics.setGravity(0, 0)

    menuButton = display.newText(sceneGroup, "Menu", display.contentCenterX, 20, native.systemFont, 30)
    menuButton:addEventListener("tap", gotomenu)

    laneLinesL = display.newRect(sceneGroup, display.contentWidth * 0.15, display.contentCenterY, 5, 3000)
    laneLinesL:setFillColor(255, 191, 0)
    laneLinesR = display.newRect(sceneGroup, display.contentWidth * 0.85, display.contentCenterY, 5, 3000)
    laneLinesR:setFillColor(255, 191, 0)

    laneLinesMR = display.newRect(sceneGroup, display.contentWidth * 0.625, display.contentCenterY, 2, 3000)
    laneLinesML = display.newRect(sceneGroup, display.contentWidth * 0.375, display.contentCenterY, 2, 3000)
   


    borderBottom = display.newRect(sceneGroup, display.contentCenterX, display.contentHeight + 200, display.contentWidth, 20)
    scoreText = display.newText(sceneGroup, "Score: 0", display.contentCenterX, 50, native.systemFont, 20)
    scoreText:setFillColor(255, 0, 0)

    liveText = display.newText(sceneGroup, "Lives: 3", display.contentCenterX, display.contentHeight + 20, native.systemFont, 20)

    userCar = display.newImageRect(sceneGroup, "Auto foto's/UserCar.png", 58, 110)
    userCar.x = display.contentWidth * 0.5
    userCar.y = display.contentHeight - 50
    rightButton = display.newRect(sceneGroup, display.contentWidth, display.contentCenterY, 200, 3000)
    rightButton:setFillColor(0.2, 0.2, 0.8, 0.01)
    leftButton = display.newRect(sceneGroup, 0, display.contentCenterY, 200, 3000)
    leftButton:setFillColor(0.2, 0.2, 0.8, 0.01)

    GreeneryR = display.newRect(sceneGroup, display.contentWidth, display.contentCenterY, 80, 3000)
    GreeneryR:setFillColor(0.2, 0.8, 0.2)
    GreeneryL = display.newRect(sceneGroup, 0, display.contentCenterY, 80, 3000)
    GreeneryL:setFillColor(0.2, 0.8, 0.2)

    physics.addBody(userCar, "dynamic", { isSensor = true })
    physics.addBody(borderBottom, "static", { isSensor = true })

    
    userCar:addEventListener("collision", onCollision)
    borderBottom:addEventListener("collision", scoreUp)
    rightButton:addEventListener("tap", moveUserCarRight)
    leftButton:addEventListener("tap", moveUserCarLeft)
    menuButton:addEventListener("tap", gotomenu)
end


function scene:show(event)
    if event.phase == "will" then
        
        score = 0
        lives = 3
        Speed = baseSpeed
        enemySpawnTime = baseTimeToSpawn
        lastSpawn = system.getTimer()

        scoreText.text = "Score: 0"
        liveText.text = "Lives: 3"

    elseif event.phase == "did" then
        
        spawnTimer = timer.performWithDelay(30, function()
            local now = system.getTimer()

            if now - lastSpawn >= enemySpawnTime then
                lastSpawn = now
                moveEnemyCar()
            end
        end, 0)
    end
end


function scene:hide(event)
    if event.phase == "will" then
        if spawnTimer then
            timer.cancel(spawnTimer)
            spawnTimer = nil
        end
    end
end


function scene:destroy(event)
    if spawnTimer then
        timer.cancel(spawnTimer)
        spawnTimer = nil
    end

    physics.stop()
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene