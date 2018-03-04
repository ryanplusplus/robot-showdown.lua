local world
local arena
local ground
local r1, r2
local sensor = {
  line = require 'src.sensor.line'
}
local ai = require 'sample.Robot'()

local Arena = require 'src.Arena'
local Robot = require 'src.Robot'

function love.load(args)
  love.window.setMode(600, 600, { resizable = true, highdpi = true })

  world = love.physics.newWorld(0, 0, false)
  arena = Arena()
  r1 = Robot(world, ai.color)
  r2 = Robot(world, { 65, 100, 65 })

  r1.place(500, 1000 * 0.75, 0)
  r2.place(500, 1000 * 0.25, math.pi)
end

function love.update(dt)
  world:update(dt)

  local function update_ai(ai)
    local inputs = {}
    for _, config in ipairs(ai.sensors) do
      inputs[config.name] = sensor[config.type](config, arena, r1)
    end
    return ai.update(dt, inputs)
  end

  r1.drive(update_ai(ai))
end

function love.draw()
  local width, height = love.window.getMode()
  local scale = math.min(width, height) / 1000
  local dx, dy = 0, 0
  if width > height then
    dx = (width - height) / 2
  else
    dy = (height - width) / 2
  end

  love.graphics.scale(scale, scale)
  love.graphics.translate(dx, dy)
  love.graphics.setBackgroundColor(150, 150, 165)

  arena:draw()
  r1:draw()
  r2:draw()
end
