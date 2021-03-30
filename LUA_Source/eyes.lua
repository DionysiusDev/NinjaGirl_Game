eyes = {}
function spawnEye(x, y)
local eye = {}
--sets single item x position
eye.x = x
--sets single item y position
eye.y = y
--used to check for item collection
eye.collected = false
--creates a grid for the sprite sheet
--sets width & height of individual images
--sets width & height of entire sprite sheet
eye.grid = anim8.newGrid(100, 50, 300, 50)
--creates animation for the item
--sets the frame from the sprite sheet
-- '1-3' tile number, 1 is the first row
-- '1-3' tile number, 2 is the second row
-- '1-2' tile number, 3 is the third row
--sets time between frame animations 0.2 seconds
eye.animation = anim8.newAnimation(eye.grid('1-3',1), 1.5)
--inserts the eyes into the eye table
table.insert(eyes, eye)
end
--function to update eyes
function eyeUpdate(dt)
  --for each eye in the table
for i,eye in ipairs(eyes) do
  --if the distance between the eyes and the player is less than 50 pixels
if distanceBetween(eye.x, eye.y, player.body:getX(), player.body:getY()) < 50 then
--sets item collected true
eye.collected = true
end
end
--for all the eyes in the table
for i =#eyes,1,-1 do
--adds eyes to array
local eye = eyes[i]
--if eye is collected
if eye.collected == true then
  --remove the eyes from the table
table.remove(eyes, i)
end
end
end