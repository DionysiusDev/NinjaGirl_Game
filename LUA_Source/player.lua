player = {}
--adds World Physics to the player
--sets player position on screen
--select static for non-moving or dynamic moving
player.body = love.physics.newBody(worldPhysics, 60, 150, "dynamic")
--creates collision box for the player and world collision
--sets width and height of the collision box in pixels
--50 increases width
--85 increases height from ground
--newRectangleShape(50, 80)
player.shape = love.physics.newRectangleShape(40, 87)
--creates fixture for the player body and shape
--this connects the player body and shape
player.fixture = love.physics.newFixture(player.body, player.shape)
--variable for player speed
player.speed = 200
--sets the player grounded
player.grounded = false
--checks if player direction is right
player.direction = 1
--checks if player direction is left
player.direction = -1
--sets player score
player.score = 0
--checks which sprite is displaying
player.sprite = sprites.player
--set the player rotation to prevent rotating when falling
player.body:setFixedRotation(true)

-- Buton properties local to game state
	local gameJumpButton = {}
	gameJumpButton.x = 250
	gameJumpButton.y = 300
	gameJumpButton.size = 30

	local gameLeftButton = {}
	gameLeftButton.x = 100
	gameLeftButton.y = 300
	gameLeftButton.size = 30

	local gameRightButton = {}
	gameRightButton.x = 400
	gameRightButton.y = 300
	gameRightButton.size = 30

--function to update player
function playerUpdate(dt)
--if the game state is not equal to menu
--allows the player to move
if state == "play" then
--if the left key is down
if love.keyboard.isDown("a") then
--sets the players x position to the current player body position
--subtracts the players speed - is left
--updates in delta time
player.body:setX(player.body:getX() - player.speed *dt)
--player direction is left
player.direction = -1
end
--if the right key is down
if love.keyboard.isDown("d") then
--sets the players x position to the current player body position
--adds the players speed + is right
--updates in delta time
player.body:setX(player.body:getX() + player.speed *dt)
--player direction is right
player.direction = 1
end
else
player.body:setX(player.body:getX())
end
-- down is for button down
down1 = love.mouse.isDown(1)
if down1 and state == "play" then -- and b == 1 and state == "play"
        --|Left direction|--
        if distanceBetweenButton(
        gameLeftButton.x, gameLeftButton.y,
        love.mouse.getX(), love.mouse.getY()) < gameLeftButton.size then
        -- | face players body - x to the left.
        -- | negative == left
        player.body:setX(player.body:getX() - player.speed * dt)
        player.direction = -1
        end
        --| this button handles the right direction |--
        if distanceBetweenButton(
        gameRightButton.x, gameRightButton.y,
        love.mouse.getX(), love.mouse.getY()) < gameRightButton.size then
        -- | face players body - x to the right.
        -- | negative == right
        player.body:setX(player.body:getX() + player.speed * dt)
        player.direction = 1
        end
      end
if down1 and state == "play" and player.grounded == true then
    -- then if the distance between buttons is: -->
    if distanceBetweenButton(
    gameJumpButton.x, gameJumpButton.y,
     love.mouse.getX(), love.mouse.getY()) < gameJumpButton.size then
     player.grounded = false
    -- | apply impulse to object on touch/mouse press event.
	  -- | impluse will be used for verticle jump when,
	  -- | the mouse button is pressed.
	  player.body:applyLinearImpulse(0, -1250) -- [-2800]-
    end
end
--if the player is on a platform
if player.grounded == true then
--sets the sprite to grounded sprite
player.sprite = sprites.player
else
--sets the sprite to jumping sprite
player.sprite = sprites.playerJump
end
end

--function to check the distance between two points
function distanceBetweenButton(x1, y1, x2, y2)
return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

return player
