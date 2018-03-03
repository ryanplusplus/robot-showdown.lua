local window = { width = 650, height = 650 }

local world
local arena
local ground
local r1, r2

local Arena = require 'src.Arena'
local Robot = require 'src.Robot'

function love.load()
  love.window.setMode(window.width, window.height)
  love.physics.setMeter(64)

  world = love.physics.newWorld(0, 0, false)
  arena = Arena(window)
  r1 = Robot(window, world)
  r2 = Robot(window, world)

  r1.place(window.width / 2, window.height * 0.75, 0)
  r2.place(window.width / 2, window.height * 0.25, math.pi)
end


function love.update(dt)
  world:update(dt)

  r1.drive(love.keyboard.isDown('left'), love.keyboard.isDown('right'))
end

function love.draw()
  love.graphics.setBackgroundColor(150, 150, 165)

  arena:draw()
  r1:draw()
  r2:draw()
end
