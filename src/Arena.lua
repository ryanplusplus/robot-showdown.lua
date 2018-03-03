return function(window)
  local x = window.width / 2
  local y = window.height / 2
  local inner_radius = (window.width * 0.8) / 2
  local outer_radius = (window.width * 0.83) / 2

  return {
    draw = function()
      love.graphics.setColor(255, 255, 255)
      love.graphics.circle('fill', x, y, outer_radius)

      love.graphics.setColor(0, 0, 0)
      love.graphics.circle('fill', x, y, inner_radius)
    end
  }
end
