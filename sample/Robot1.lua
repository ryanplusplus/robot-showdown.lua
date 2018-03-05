return function()
  return {
    name = 'Robot 1',

    color = { 65, 65, 100 },

    sensors = {
      { type = 'line', name = 'line_front_center', position = { x = 0.0, y = 1.0 } }
    },

    update = coroutine.wrap(function(dt, sensor)
      local time

      while true do
        if sensor.line_front_center then
          time = 0
          while time < 0.2 do
            dt, sensor = coroutine.yield(-1, -1)
            time = time + dt
          end

          time = 0
          while time < 0.2 do
            dt, sensor = coroutine.yield(-1, 1)
            time = time + dt
          end
        else
          dt, sensor = coroutine.yield(1, 1)
        end
      end
    end)
  }
end
