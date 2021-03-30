-- playstate
local play = {}

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

function play.load ()
lives = 3 --sets play lives
--sets score
score = 0
--adds the physics to the worlds x and y position
--set false to allow players to fall off platforms
worldPhysics = love.physics.newWorld(gravityX, gravityY, false)
--sets world callbacks
worldPhysics:setCallbacks(beginContact, endContact, preSolve, postSolve)
--sets sprites table
sprites = {}
--sprite for the collectable items
sprites.items = love.graphics.newImage("/assets/sprites/item.png")
--sprite for the eyes
sprites.eyes = love.graphics.newImage("/assets/sprites/eyes.png")
--sprite for the jumping player
sprites.playerJump = love.graphics.newImage("/assets/sprites/player_jump.png")
--sprite for the standing player
sprites.player = love.graphics.newImage("/assets/sprites/healthStar.png")
--sprite for the gui scoreboard
sprites.scorebg = love.graphics.newImage("/assets/sprites/ScoreBG.png")
--calls required menu.lua file
require("menu")
--calls required player.lua file
require("player")
--calls required gameover.lua file
require("gameover")
--calls required item.lua file
require("item")
--calls required eyes.lua file
require("eyes")
--calls to required anim8 third-party source package
anim8 = require("/assets/libs/anim8-master/anim8")
--calls the simple tile implementation third party source package
sti = require("/assets/libs/Simple-Tiled-Implementation-master/sti")
--calls to the camera.lua file from the helper utility third-party source package
cameraFile = require("/assets/libs/hump-master/camera")
--image for player health
health = love.graphics.newImage("assets/sprites/healthStar.png")
--image for score background
scorebackground = love.graphics.newImage("assets/sprites/ScoreBG.png")
--sets the camera file to a variable cameraFile
--this is used to call camera attributes
camera = cameraFile()
--sets platform table
platforms = {}
leftTouches = {}
rightTouches = {}
--sets the map from tiled export
tilemap = sti("/assets/map/tilemap.lua")
--counts through the items in the item layer tile map
for i,obj in pairs(tilemap.layers["Items"].objects) do
--spawns the items from the tiled tilemap items layer
spawnItem(obj.x, obj.y)
end
--counts through the items in the item layer tile map
for i,obj in pairs(tilemap.layers["Eyes"].objects) do
--spawns the items from the tiled tilemap items layer
spawnEye(obj.x, obj.y)
end
end

function play.update(dt)
--updates the worlds physics in delta time
worldPhysics:update(dt)
--updates player from player.lua update function
playerUpdate(dt)
--updates the tilemap in delta time
tilemap:update(dt)
--updates the items in delta time
eyeUpdate(dt)
--updates the items in delta time
itemUpdate(dt)

--updates camera to follow the player
--gets the height of the y axis
camera:lookAt(player.body:getX(), (love.graphics.getHeight()/8) + player.body:getY())
--updates each item in the items table
for i,item in ipairs(items) do
--updates animations
if distanceBetween(item.x, item.y, player.body:getX(), player.body:getY()) < 350 then
--updates the item(s) animation in delta time
item.animation:update(dt)
end
end
for i,eye in ipairs(eyes) do
if distanceBetween(eye.x, eye.y, player.body:getX(), player.body:getY()) < 300 then
--updates the item(s) animation in delta time
eye.animation:update(dt)
end
end
--if there are no items & game state is play
if #items == 0 and state == "play" then
	score = (score * 2)
	bgMusicSource:stop()
player.body:setPosition(50, 200)
player.direction = 1
end
--if player is below screen level reset
--remove a life
--respawn items
if state == "play" and player.body:getY() > 500 then
score = (score - 100)
lives = (lives - 1)
--sets player to spawn
player.body:setPosition(50, 200)
player.direction = 1
items = {}
end
--if the player is out of lies re-start game
if state == "play" and lives == 0 then
	bgMusicSource:stop()
state = "gameover"
--sets player to spawn
player.body:setPosition(50, 200)
player.direction = 1
items = {}
eyes = {}
end
--checks if there are no items
if #items == 0 then
--counts through the items in the item layer tile map
for i,obj in pairs(tilemap.layers["Items"].objects) do
--spawns the items from the tiled tilemap items layer
spawnItem(obj.x, obj.y)
bgMusicSource:play()
end
--counts through the items in the item layer tile map
for i,obj in pairs(tilemap.layers["Eyes"].objects) do
--spawns the items from the tiled tilemap items layer
spawnEye(obj.x, obj.y)
end
end
end -- end

function resetColour()
love.graphics.setColor(255, 255, 255) --sets next colour to default
end
--| draws our game buttons to the screen in the x and y positions
--| draw our game buttons for left right direction and jump
function drawJumpButton()
	love.graphics.setColor(255, 0, 171, 0.81)
	love.graphics.print("^", (gameJumpButton.x - 12), (gameJumpButton.y - 10))
	love.graphics.circle("line", gameJumpButton.x, gameJumpButton.y, gameJumpButton.size) -- jump button
	resetColour()
end

--draws hud scoreboard
function drawScoreboard()
	--draws the score background
 love.graphics.draw(scorebackground, 10, 135)
 --set score font colour
 love.graphics.setColor(love.math.random(0, 1), love.math.random(0,1), love.math.random(0,1))
 --instantiates font && size
 scoreFont = love.graphics.newFont(30)
 --sets the gameover font
 love.graphics.setFont(scoreFont)
 --prints score
 love.graphics.print(score, 75, 131)
 resetColour()
end

--draws player health
function paintHealth()
  if lives == 3 then
    love.graphics.draw(health, 5, 50)
		love.graphics.draw(health, 55, 50)
		love.graphics.draw(health, 105, 50)
  end
  if lives == 2 then
		love.graphics.draw(health, 5, 50)
		love.graphics.draw(health, 55, 50)
  end
  if lives == 1 then
		love.graphics.draw(health, 5, 50)
  end
end

--| draw our game buttons for left right direction and jump
function drawLeftButton()
love.graphics.setColor(255, 0, 171, 0.81)
	love.graphics.print("<", (gameLeftButton.x - 13), (gameLeftButton.y - 17))
	love.graphics.circle("line", gameLeftButton.x, gameLeftButton.y, gameLeftButton.size) -- left movement Button
	resetColour()
end
--| draw our game buttons for left right direction and jump
function drawRightButton()
	love.graphics.setColor(255, 0, 171, 0.81)
		love.graphics.print(">", (gameRightButton.x - 10), (gameRightButton.y - 18))
	love.graphics.circle("line", gameRightButton.x, gameRightButton.y, gameRightButton.size) -- left movement Button
	resetColour()
end

function play.draw()
--attaches the camera to the player
camera:attach()
	--draws each item in the eyes table
    for e,eye in ipairs(eyes) do
    --draws the item sprite
    --sets item offset to half the items width and height
    eye.animation:draw(sprites.eyes, eye.x, eye.y)
    end
  --draws the background objects tile map
  tilemap:drawLayer(tilemap.layers["background_objects"])
  --draws the platform_tiles tile map
  tilemap:drawLayer(tilemap.layers["platform_tiles"])
  --draws the player with the physics body
  -- sets the physics box to the player width / 1.7
  -- sets the physics box to the player height / 1.68
  --adjust player direction if the player looks left/right
  love.graphics.draw(player.sprite, player.body:getX(), player.body:getY(), nil, player.direction, 1, sprites.player:getWidth() / 1.7, sprites.player:getHeight() / 1.68)
--draws the foreground tile map
tilemap:drawLayer(tilemap.layers["foreground"])
    --draws each item in the items table
    for i,item in ipairs(items) do
    --draws the item sprite
    --sets item offset to half the items width and height
    item.animation:draw(sprites.items, item.x, item.y, nil, nil, nil, 20.5, 21)
    end
  --detaches the camera from the player
camera:detach()
  --draw HUD after camera detach
--draws the UI tile map
tilemap:drawLayer(tilemap.layers["UI"])
drawScoreboard() --draws the hud score board
--draws player health
paintHealth()
--instantiates font && size
btnFont = love.graphics.newFont(30)
--sets the gameover font
love.graphics.setFont(btnFont)
--draws multi touch colours
drawTouches()
drawJumpButton() -- draw the jump[^--<>--^] button to the screen
drawLeftButton() -- draw the left[-->] button to the screen
drawRightButton() -- draw the jump[<--] button to the screen
end

--draws the left button touches
function drawTouches()
Touches = love.touch.getTouches()
for i, t in ipairs(Touches) do
x, y = love.touch.getPosition(t)
love.graphics.setColor(255, 0, 171, 0.81) -- draws touch colour
love.graphics.circle("fill", x, y, 20)
resetColour()
end
end

-- | will play sound on collection
function collectSound()
	if state == "play" then
	--| create our button audio source and play it on the menu screen.
	--| create our audio source and play it on the menu screen.
	love.audio.setVolume(soundLevel + 0.2) -- 1.0 is max and 0.0 is off.
	love.audio.setEffect('myEffect', {type = 'reverb'})
	local source = love.audio.newSource("/assets/music/collect.wav", "static")
	source:setEffect('myEffect')
	source:play() -- plays our source file
end
end

--function for creating platforms
function spawnPlatform(x, y, width, height)
--platform table
local platform = {}
--sets new platform with world physics and sets non moving "static"
platform.body = love.physics.newBody(worldPhysics, x, y, "static")
--sets platform shape - width & height
--sets platforms offset to draw from top left corner
platform.shape = love.physics.newRectangleShape(width / 2, height / 2, width, height)
--connects the platform body and shape using a fixture
platform.fixture = love.physics.newFixture(platform.body, platform.shape)
--instantiates variable to store width
platform.width = width
--instantiates variable to store height
platform.height = height
--inserts the platform in the platforms table
table.insert(platforms, platform)
end

--function for key pressed events
function play.keypressed(key, scancode, isrepeat)
  --space key event checks if the player is on the ground
  if key == "space" and player.grounded == true then
    --adds linear impulse to players upward position Y
    --allows for jumping
    player.body:applyLinearImpulse(0, -1250)
  end

if key == "escape" and state == "play" then
	state = "gameover"
	--sets player to spawn
	player.body:setPosition(50, 200)
	player.direction = 1
	items = {}
	eyes = {}
	bgMusicSource:stop()
end
end

--function for checking collision contact start
function beginContact(a, b, collision)
--sets the player grounded true on collision
player.grounded = true
end
--function for checking collision contact end
function endContact(a, b, collision)
--sets the player grounded false after collision or on jumping
player.grounded = false
end
--| calculates the distance between the mouse pointer and the button
function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end
-- return play state
return play
