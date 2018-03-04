return function(window)
  local x = window.size / 2
  local y = window.size / 2
  local inner_radius = (window.size * 0.8) / 2
  local outer_radius = (window.size * 0.84) / 2
  local inner_circle = love.physics.newCircleShape(x, y, inner_radius)
  local outer_circle = love.physics.newCircleShape(x, y, outer_radius)

  return {
    draw = function()
      love.graphics.setColor(255, 255, 255)
      love.graphics.circle('fill', x, y, outer_radius)

      love.graphics.setColor(0, 0, 0)
      love.graphics.circle('fill', x, y, inner_radius)
    end,

    point_location = function(x, y)
      if inner_circle:testPoint(0, 0, 0, x, y) then
        return 'inside'
      elseif outer_circle:testPoint(0, 0, 0, x, y) then
        return 'border'
      else
        return 'outside'
      end
    end
  }
end
