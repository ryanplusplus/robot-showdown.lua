local size = 1000

return function()
  local x = 1000 / 2
  local y = 1000 / 2
  local inner_radius = (1000 * 0.8) / 2
  local outer_radius = (1000 * 0.84) / 2
  local inner_circle = love.physics.newCircleShape(x, y, inner_radius)
  local outer_circle = love.physics.newCircleShape(x, y, outer_radius)

  return {
    draw = function()
      love.graphics.setColor(255, 255, 255)
      love.graphics.circle('fill', x, y, outer_radius)

      love.graphics.setColor(0, 0, 0)
      love.graphics.circle('fill', x, y, inner_radius)
    end,

    at = function(x, y)
      if inner_circle:testPoint(0, 0, 0, x, y) then
        return 'inside'
      elseif outer_circle:testPoint(0, 0, 0, x, y) then
        return 'line'
      else
        return 'outside'
      end
    end
  }
end
