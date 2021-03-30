-- menustate
local menu = {}
state = "menu"

playButton = {}
playButton.x = 100
playButton.y = 300
playButton.size = 30

soundLevel = 0.5
soundLevelMax = 0.9
soundLevelMin = 0.1

soundsDown = false
soundDownButton = {}
soundDownButton.x = 250
soundDownButton.y = 300
soundDownButton.size = 30

soundsUp = false
soundUpButton = {}
soundUpButton.x = 400
soundUpButton.y = 300
soundUpButton.size = 30

--instantiates menu font && size
menuFont = love.graphics.newFont(30)
menuHelpFont = love.graphics.newFont(17)

---- | will play sound on button press events
function buttonSound()
--| create our button audio source and play it on the menu screen.
love.audio.setVolume(soundLevel) -- 1.0 is max and 0.0 is off.
love.audio.setEffect('myEffect', {type = 'reverb'})
btnSoundSource = love.audio.newSource("/assets/music/button.wav", "static")
btnSoundSource:setEffect('myEffect')
btnSoundSource:play() -- plays our source file
--sfx = love.audio.newSource("assets/music/button_sound_001.ogg", "stream")
--love.audio.play(sfx)
end

--draws the menu
function menu.draw()
    if state == "menu" then
--set intitial colour
love.graphics.setColor(0, 0, 0, 0)
--set intitial button colour
love.graphics.setColor(255, 0, 171, 0.81)
--sets the menu font
love.graphics.setFont(menuFont)
--prints the font text
love.graphics.printf("Press [S] Button to Start!", 0,50, love.graphics.getWidth(), "center")
love.graphics.setFont(menuHelpFont)
love.graphics.printf("Press [Space] To Jump", 0, 100, love.graphics.getWidth(), "center")           -- display user help
love.graphics.printf("Press [A] To Move Player Left", 0, 140, love.graphics.getWidth(), "center")   -- display user help
love.graphics.printf("Press [D] To Move Player Right", 0, 180, love.graphics.getWidth(), "center")  -- display user help
love.graphics.printf("Press [ESCAPE] To Quit", 0, 220, love.graphics.getWidth(), "center")  -- display user help
--sets the menu font
love.graphics.setFont(menuFont)
if state == "menu" and soundsDown == true then
soundDown()
end
if state == "menu" and soundsUp == true then
soundUp()
end
drawMenuButton()
end
end

--turns sound down
function soundDown()
if soundLevel >= soundLevelMin then
--prints the font text
love.graphics.printf("Sound Decreased: "..soundLevel, 0,10, love.graphics.getWidth(), "center")
soundsDown = false
end
end
--turns sound up
function soundUp()
if soundLevel <= soundLevelMax then
--prints the font text
love.graphics.printf("Sound Increased: "..soundLevel, 0,10, love.graphics.getWidth(), "center")
soundsUp = false
end
end

--| draws our menu buttons to the screen in the x and y positions
function drawMenuButton()
love.graphics.print("S", playButton.x - 10, playButton.y - 18)
--draws the play button
love.graphics.circle("line", playButton.x, playButton.y, playButton.size)
love.graphics.print("-", soundDownButton.x - 5, soundDownButton.y - 18)
--draws the sound down button
love.graphics.circle("line", soundDownButton.x, soundDownButton.y, soundDownButton.size)
love.graphics.print("+", soundUpButton.x - 12, soundUpButton.y - 18)
--draws the sound up button
love.graphics.circle("line", soundUpButton.x, soundUpButton.y, soundUpButton.size)
-- image buttons
--btn1 = love.graphics.draw(btnImages, btn1x, btn1y) -- draw button 1
--btn2 = love.graphics.draw(btnImages, btn2x, btn2y) -- draw button 2
--btn3 = love.graphics.draw(btnImages, btn3x, btn3y) -- draw button 2
end

-- | will play bg music and possibly cause out of memory error
function bgMusic(dt)
	--| create our button audio source and play it on the play state.
	--| create our audio source and play it on the menu screen.
	love.audio.setVolume(soundLevel) -- 1.0 is max and 0.0 is off.
	love.audio.setEffect('myEffect', {type = 'reverb'})
    bgMusicSource:setEffect('myEffect')
	bgMusicSource:play()
end

--update menu in delta time
function menu.update(dt)
    --update background instrumental in delta time
    bgMusic(dt)
end

--mouse pressed function
function menu.mousepressed( x, y, b) -- , istouch
  if b == 1 and state == "menu" then
	buttonSound()
    if distanceBetween(playButton.x, playButton.y, love.mouse.getX(), love.mouse.getY()) < playButton.size then
    state = "play" -- change to play state
    score = 0
    lives = 3
    end
    if distanceBetween(soundDownButton.x, soundDownButton.y, love.mouse.getX(), love.mouse.getY()) < soundDownButton.size then
	soundsDown = true
	if soundLevel > soundLevelMin then
	soundLevel = soundLevel - 0.1
	end
    end
    if distanceBetween(soundUpButton.x, soundUpButton.y, love.mouse.getX(), love.mouse.getY()) < soundUpButton.size then
	soundsUp = true
	if soundLevel < soundLevelMax then
	soundLevel = soundLevel + 0.1
	end
    end
  end
end
--| calculates the distance between the mouse pointer and the button
function distanceBetween(x1, y1, x2, y2)
  return math.sqrt((y2 - y1)^2 + (x2 - x1)^2)
end
--add key pressed modulesfor functions here
function menu.keypressed(key)
    if key == "s" and state == "menu" then
          state = "play"
          score = 0
          lives = 3
  		end
      if key == "escape" and state == "menu" then
            love.event.quit()
    		end
end
-- return menu to main
return menu
