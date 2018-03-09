local render_size = 1000

local ai1 = require 'sample.Robot1'()
local ai2 = require 'sample.Robot2'()

local Arena = require 'src.Arena'
local Robot = require 'src.Robot'
local Update = require 'src.Update'

local world
local arena
local update
local r1, r2
local sensor = {
  line = require 'src.sensor.line'
}

function love.load(args)
  local width, height = love.window.getMode()
  love.window.setMode(width, height, { resizable = true })

  world = love.physics.newWorld(0, 0, false)
  arena = Arena()
  r1 = Robot(world, ai1.color)
  r2 = Robot(world, ai2.color)

  r1.place(render_size / 2, render_size * 0.75, 0)
  r2.place(render_size / 2, render_size * 0.25, math.pi)

  update = Update(arena, sensor)
end

local winner

function love.update(dt)
  if not winner then
    world:update(dt)

    if arena.at(r1.position()) == 'outside' then
      winner = ai2
    elseif arena.at(r2.position()) == 'outside' then
      winner = ai1
    else
      r1.drive(update(ai1, r1, r2, dt))
      r2.drive(update(ai2, r2, r1, dt))
    end
  end
end

function love.draw()
  local width, height = love.window.getMode()
  local scale = math.min(width, height) / render_size
  local dx, dy = 0, 0
  if width > height then
    dx = (width - height) / 2
  else
    dy = (height - width) / 2
  end

  love.graphics.translate(dx, dy)
  love.graphics.scale(scale, scale)
  love.graphics.setBackgroundColor(150, 150, 165)

  arena:draw()
  r1:draw()
  r2:draw()

  if winner then
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(love.graphics.newFont(60))
    love.graphics.printf(winner.name .. ' is winnar', width / 2 - dx, height / 2, scale * render_size, 'left')
  end
end
