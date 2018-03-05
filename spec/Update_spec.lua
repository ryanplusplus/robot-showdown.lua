describe('Update', function()
  local mach = require 'mach'
  local Update = require 'Update'

  it('should call the robot AI update function with sensor data ', function()
    local arena = {}
    local sensor = mach.mock_table({
      line = function() end,
      range = function() end
    }, 'sensor')
    local this = {}
    local that = {}
    local ai = {
      sensors = {
        { type = 'line', name = 'line_sensor' },
        { type = 'range', name = 'range_sensor' }
      },
      update = mach.mock_function('ai.update')
    }

    sensor.line:should_be_called_with(mach.match(ai.sensors[1]), arena, this, that):and_will_return('line_output'):
      and_also(sensor.range:should_be_called_with(mach.match(ai.sensors[2]), arena, this, that):and_will_return('range_output')):
      and_then(ai.update:should_be_called_with(0.05, mach.match{ line_sensor = 'line_output', range_sensor = 'range_output' })):
      when(function()
        Update(arena, sensor)(ai, this, that, 0.05)
      end)
  end)
end)
