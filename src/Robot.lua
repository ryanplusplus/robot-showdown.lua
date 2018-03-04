local function RobotTread(window, world)
  local width = window.size / 45
  local height = window.size / 10
  local body = love.physics.newBody(world, 0, 0, 'dynamic')
  local shape = love.physics.newRectangleShape(width, height)
  local fixture = love.physics.newFixture(body, shape)

  body:setMass(15)
  body:setLinearDamping(15)
  fixture:setFriction(0.6)
  fixture:setRestitution(0.75)

  return {
    body = body,
    width = width,
    height = height,

    drive = function(power)
      local max_f = 130000

      local f = max_f * power
      local w = body:getAngle()
      local fx = math.sin(w) * f
      local fy = -math.cos(w) * f
      body:applyForce(fx, fy, body:getX(), body:getY())
    end,

    draw = function()
      love.graphics.setColor(125, 125, 125)
      love.graphics.polygon('fill', body:getWorldPoints(shape:getPoints()))
    end
  }
end

local function RobotChassis(window, world, color)
  local width = window.size / 16
  local height = window.size / 11
  local body = love.physics.newBody(world, 0, 0, 'dynamic')
  local shape = love.physics.newRectangleShape(width, height)
  local fixture = love.physics.newFixture(body, shape)

  fixture:setFriction(0.4)
  fixture:setRestitution(0)

  return {
    body = body,
    width = width,
    height = height,

    draw = function()
      love.graphics.setColor(unpack(color))
      love.graphics.polygon('fill', body:getWorldPoints(shape:getPoints()))
    end
  }
end

return function(window, world, color)
  local left_tread = RobotTread(window, world)
  local right_tread = RobotTread(window, world)
  local chassis = RobotChassis(window, world, color)

  local tread_offset = chassis.width / 2 + left_tread.width / 2

  left_tread.body:setPosition(chassis.body:getX() - tread_offset, chassis.body:getY())
  right_tread.body:setPosition(chassis.body:getX() + tread_offset, chassis.body:getY())

  love.physics.newWeldJoint(
    chassis.body,
    right_tread.body,
    right_tread.body:getX() - right_tread.width / 2,
    right_tread.body:getY(),
    false
  )

  love.physics.newWeldJoint(
    chassis.body,
    left_tread.body,
    left_tread.body:getX() + left_tread.width / 2,
    left_tread.body:getY(),
    false
  )

  return {
    position = function()
      return chassis.body:getX(), chassis.body:getY()
    end,

    place = function(x, y, w)
      chassis.body:setAngle(w)
      chassis.body:setPosition(x, y)
      chassis.body:setLinearVelocity(0, 0)
      chassis.body:setAngularVelocity(0)

      left_tread.body:setAngle(w)
      left_tread.body:setPosition(x - tread_offset * math.cos(w), y)
      left_tread.body:setLinearVelocity(0, 0)
      left_tread.body:setAngularVelocity(0)

      right_tread.body:setAngle(w)
      right_tread.body:setPosition(x + tread_offset * math.cos(w), y)
      right_tread.body:setLinearVelocity(0, 0)
      right_tread.body:setAngularVelocity(0)
    end,

    drive = function(left, right)
      left_tread.drive(left)
      right_tread.drive(right)
    end,

    draw = function()
      chassis.draw()
      left_tread.draw()
      right_tread.draw()
    end
  }
end
