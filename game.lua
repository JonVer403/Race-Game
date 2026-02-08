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
local lastSpawn = 0 -- IMPORTANT: used for dynamic spawn timing

-- DISPLAY OBJECTS (declared here, created later)
local borderBottom, scoreText, liveText
local userCar, rightButton, leftButton

----------------------------------------------------------
-- ENEMY SPAWNING
----------------------------------------------------------
local function moveEnemyCar()
    local lanes = {
        display.contentWidth * 0.25,
        display.contentWidth * 0.5,
        display.contentWidth * 0.75
    }

    local laneIndex = math.random(1, 3)
    local enemyX = lanes[laneIndex]

    local enemyCar = display.newRect(enemyX, -50, 50, 80)
    physics.addBody(enemyCar, "dynamic", { isSensor = true })
    enemyCar:setLinearVelocity(0, Speed)

    table.insert(enemyCars, enemyCar)
    scene.view:insert(enemyCar)
end

----------------------------------------------------------
-- PLAYER MOVEMENT
----------------------------------------------------------
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

----------------------------------------------------------
-- COLLISION HANDLING
----------------------------------------------------------
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

        -- Remove the enemy that hit the player
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

----------------------------------------------------------
-- SCORE UP
----------------------------------------------------------
local function scoreUp(event)
    if event.phase == "began" then
        score = score + 1
        scoreText.text = "Score: " .. score

        -- Update speed and spawn rate
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

----------------------------------------------------------
-- SCENE CREATE
----------------------------------------------------------
function scene:create(event)
    local sceneGroup = self.view

    physics.start()
    physics.setGravity(0, 0)

    -- CREATE OBJECTS INSIDE THE SCENE
    borderBottom = display.newRect(sceneGroup, display.contentCenterX, display.contentHeight + 200, display.contentWidth, 20)
    scoreText = display.newText(sceneGroup, "Score: 0", display.contentCenterX, 50, native.systemFont, 20)
    liveText = display.newText(sceneGroup, "Lives: 3", display.contentCenterX, display.contentCenterY + 300, native.systemFont, 20)

    userCar = display.newRect(sceneGroup, display.contentCenterX, display.contentHeight - 50, 50, 100)
    rightButton = display.newRect(sceneGroup, display.contentWidth - 50, display.contentHeight - 50, 80, 80)
    leftButton = display.newRect(sceneGroup, 50, display.contentHeight - 50, 80, 80)

    physics.addBody(userCar, "dynamic", { isSensor = true })
    physics.addBody(borderBottom, "static", { isSensor = true })

    -- EVENT LISTENERS
    userCar:addEventListener("collision", onCollision)
    borderBottom:addEventListener("collision", scoreUp)
    rightButton:addEventListener("tap", moveUserCarRight)
    leftButton:addEventListener("tap", moveUserCarLeft)
end

----------------------------------------------------------
-- SCENE SHOW
----------------------------------------------------------
function scene:show(event)
    if event.phase == "will" then
        -- Reset game state
        score = 0
        lives = 3
        Speed = baseSpeed
        enemySpawnTime = baseTimeToSpawn
        lastSpawn = system.getTimer()

        scoreText.text = "Score: 0"
        liveText.text = "Lives: 3"

    elseif event.phase == "did" then
        -- Start dynamic spawn timer
        spawnTimer = timer.performWithDelay(30, function()
            local now = system.getTimer()

            if now - lastSpawn >= enemySpawnTime then
                lastSpawn = now
                moveEnemyCar()
            end
        end, 0)
    end
end

----------------------------------------------------------
-- SCENE HIDE
----------------------------------------------------------
function scene:hide(event)
    if event.phase == "will" then
        if spawnTimer then
            timer.cancel(spawnTimer)
            spawnTimer = nil
        end
    end
end

----------------------------------------------------------
-- SCENE DESTROY
----------------------------------------------------------
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