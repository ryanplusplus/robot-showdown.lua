local function RobotTread(window, world)
  local width = window.width / 45
  local height = window.height / 10
  local body = love.physics.newBody(world, 0, 0, 'dynamic')
  local shape = love.physics.newRectangleShape(width, height)
  local fixture = love.physics.newFixture(body, shape)

  body:setMass(15)
  body:setLinearDamping(50)
  fixture:setFriction(0.6)
  fixture:setRestitution(0.75)

  return {
    body = body,
    width = width,
    height = height,

    draw = function()
      love.graphics.setColor(125, 125, 125)
      love.graphics.polygon('fill', body:getWorldPoints(shape:getPoints()))
    end
  }
end

local function RobotChassis(window, world)
  local width = window.width / 16
  local height = window.height / 11
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
      love.graphics.setColor(65, 65, 100)
      love.graphics.polygon('fill', body:getWorldPoints(shape:getPoints()))
    end
  }
end

return function(window, world)
  local left_tread = RobotTread(window, world)
  local right_tread = RobotTread(window, world)
  local chassis = RobotChassis(window, world)

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
    body = chassis.body,

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
      if left then
        local f = 200000
        local w = left_tread.body:getAngle()
        local fx = math.sin(w) * f
        local fy = -math.cos(w) * f
        left_tread.body:applyForce(fx, fy, left_tread.body:getX(), left_tread.body:getY())
      end

      if right then
        local f = 200000
        local w = left_tread.body:getAngle()
        local fx = math.sin(w) * f
        local fy = -math.cos(w) * f
        right_tread.body:applyForce(fx, fy, right_tread.body:getX(), right_tread.body:getY())
      end
    end,

    draw = function()
      chassis.draw()
      left_tread.draw()
      right_tread.draw()
    end
  }
end
