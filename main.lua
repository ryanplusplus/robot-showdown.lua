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
  r1 = Robot(window, world, { 65, 65, 100 })
  r2 = Robot(window, world, { 65, 100, 65 })

  r1.place(window.width / 2, window.height * 0.75, 0)
  r2.place(window.width / 2, window.height * 0.25, math.pi)
end


function love.update(dt)
  world:update(dt)

  r1.drive(
    love.keyboard.isDown('left') and 1 or 0,
    love.keyboard.isDown('right') and 1 or 0
  )
  r2.drive(
    love.keyboard.isDown('z') and 1 or 0,
    love.keyboard.isDown('x') and 1 or 0
  )

  print('---')
  print('r1', arena.point_location(r1.position()))
  print('r2', arena.point_location(r2.position()))
end

function love.draw()
  love.graphics.setBackgroundColor(150, 150, 165)

  arena:draw()
  r1:draw()
  r2:draw()
end
