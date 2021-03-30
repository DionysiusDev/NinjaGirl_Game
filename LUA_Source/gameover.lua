-- gameover state
local gameover = {}
state = "gameover"

--instantiates menu button size and location
local gameoverButton = {}
gameoverButton.x = 240
gameoverButton.y = 300
gameoverButton.size = 30

--instantiates gameover font && size
gameoverFont = love.graphics.newFont(30)

--resets colour
function resetColour()
  --set intitial colour
  love.graphics.setColor(0, 0, 0, 0)
end

--draws the gameover state
function gameover.draw()
  if state == "gameover" then
--set intitial button colour
love.graphics.setColor(255, 0, 171, 0.81)
--sets the gameover font
love.graphics.setFont(gameoverFont)
--prints the font text
love.graphics.printf("Game Over", 0,50, love.graphics.getWidth(), "center")
--instantiates menu font && size
overFont = love.graphics.newFont(50)
--sets the gameover font
love.graphics.setFont(overFont)
--set intitial button colour
love.graphics.setColor(love.math.random(0, 1), love.math.random(0,1), love.math.random(0,1))
--prints the font text
love.graphics.printf("Score = " .. score, 0,100, love.graphics.getWidth(), "center")
--sets the gameover font
love.graphics.setFont(gameoverFont)
drawGOButton()
--draws multi touch colours
drawTouches()
end
end

--draws game over button to the screen in the x and y positions
function drawGOButton()
  --set intitial button colour
  love.graphics.setColor(255, 0, 171, 0.81)
--prints the font text
love.graphics.printf("Press M Button for Menu!", 0,200, love.graphics.getWidth(), "center")
--draws the sound down button
love.graphics.print("M", gameoverButton.x -13, gameoverButton.y - 18)
love.graphics.circle("line", gameoverButton.x, gameoverButton.y, gameoverButton.size)
resetColour()
end

--draws the button touches
function drawTouches()
Touches = love.touch.getTouches()
for i, t in ipairs(Touches) do
x, y = love.touch.getPosition(t)
love.graphics.setColor(255, 0, 171, 0.81) -- draws touch colour
love.graphics.circle("fill", x, y, 20)
resetColour()
end
end

--mouse pressed function
function gameover.mousepressed( x, y, b) -- , istouch
  if b == 1 and state == "gameover" then
    if distanceBetween(gameoverButton.x, gameoverButton.y, love.mouse.getX(), love.mouse.getY()) < gameoverButton.size then
    state = "menu" -- change to menu state
    end
  end
end

--add key pressed modulesfor functions here
function gameover.keypressed(key)
	if key == "m" and state == "gameover" then
        state = "menu"
		end
end

--| calculates the distance between the mouse pointer and the button
function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end

-- return gameover to main
return gameover
