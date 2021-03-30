-- main.lua entry point
-- state is global it will exsit every where.
state = "main"
-- how to add required files
local gameover = require("gameover")
local menu = require("menu")
local play = require("play")

function love.load ()
love.window.setMode(500, 350)
--sets score
score = 0
--sets lives
lives = 3
--set horizontal then vertical gravity
gravityX = 0
gravityY = 500
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
sprites.player = love.graphics.newImage("/assets/sprites/player_stand.png")
--sprite for the gui stars
sprites.health = love.graphics.newImage("/assets/sprites/healthStar.png")
--sprite for the gui scoreboard
sprites.scorebg = love.graphics.newImage("/assets/sprites/ScoreBG.png")
--calls required player.lua file
require("player")
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
--sets the camera file to a variable cameraFile
--this is used to call camera attributes
camera = cameraFile()
bgMusicSource = love.audio.newSource("assets/music/bgInstra.ogg", "stream")
--sets platform table
platforms = {}
--sets the map from tiled export
tilemap = sti("/assets/map/tilemap.lua")
--calls to the camera.lua file from the helper utility third-party source package
cameraFile = require("/assets/libs/hump-master/camera")
--image for player health
health = love.graphics.newImage("assets/sprites/healthStar.png")
--image for score background
scorebackground = love.graphics.newImage("assets/sprites/ScoreBG.png")
--sets the camera file to a variable cameraFile
--this is used to call camera attributes
camera = cameraFile()
--gets all the objects in the platform layer from tiled tilemap.lua
for i,obj in pairs(tilemap.layers["Platforms"].objects) do
--spawns the platforms from the tiled tilemap settings
spawnPlatform(obj.x, obj.y, obj.width, obj.height)
end
end

--update menu in delta time
function love.update(dt)
  if state == "menu" then
      menu.update(dt)
  end
  if state == "play" then
      play.update(dt)
  end
end

-- Add callback functions here
function love.draw()
    if state == "play" then
        play.draw()
		end
    if state == "gameover" then
        gameover.draw()
		end
		if state == "menu" then
        menu.draw()
		end
	end

--add key pressed modules for functions here
function love.keypressed(key)
	if state == "menu" then
        menu.keypressed(key)
		end
    if state == "play" then
        play.keypressed(key)
		end
    if state == "gameover" then
        gameover.keypressed(key)
		end
end

--add mouse pressed modules for functions
function love.mousepressed(x, y, b)
	if state == "menu" then
        menu.mousepressed(x, y, b)
		end
    if state == "gameover" then
        gameover.mousepressed(x, y, b)
		end
end
