items = {}

function spawnItem(x, y)
local item = {}
--sets single item x position
item.x = x
--sets single item y position
item.y = y
--used to check for item collection
item.collected = false
--creates a grid for the sprite sheet
--sets width & height of individual images
--sets width & height of entire sprite sheet
item.grid = anim8.newGrid(50, 50, 350, 50)
--creates animation for the item
--sets the frame from the sprite sheet
-- '1-3' tile number, 1 is the first row
-- '1-3' tile number, 2 is the second row
-- '1-2' tile number, 3 is the third row
--sets time between frame animations 0.2 seconds
item.animation = anim8.newAnimation(item.grid('1-5',1), 0.1)
--inserts the item into the items table
table.insert(items, item)
end
--function to update items
function itemUpdate(dt)
  --for each item in the table
for i,item in ipairs(items) do
  --if the distance between the item and the player is less than 50 pixels
if distanceBetween(item.x, item.y, player.body:getX(), player.body:getY()) < 70 then
--sets item collected true
item.collected = true
collectSound()
--adds ten points to player score
score = score + 10
end
end
--for all the items in the table
for i =#items,1,-1 do
--adds items to array
local item = items[i]
--if item is collected
if item.collected == true then
  --remove the item from the table
table.remove(items, i)
end
end
end
