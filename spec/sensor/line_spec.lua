describe('sensor.line', function()
  local mach = require 'mach'
  local line = require 'sensor.line'

  local arena = {
    at = mach.mock_function('arena.at')
  }

  local robot = {
    point_at = mach.mock_function('robot.point_at')
  }

  it('should return true if the sensor is over the line', function()
    robot.point_at:should_be_called_with(0.5, 0.76):and_will_return(123, 456):
      and_then(arena.at:should_be_called_with(123, 456):and_will_return('line')):
      when(function()
        assert.is_true(line({ position = { x = 0.5, y = 0.76 } }, arena, robot))
      end)
  end)

  it('should return false if the sensor is inside the arena', function()
    robot.point_at:should_be_called_with(0.5, 0.76):and_will_return(123, 456):
      and_then(arena.at:should_be_called_with(123, 456):and_will_return('inside')):
      when(function()
        assert.is_false(line({ position = { x = 0.5, y = 0.76 } }, arena, robot))
      end)
  end)

  it('should return false if the sensor is outside the arena', function()
    robot.point_at:should_be_called_with(0.45, 0.6):and_will_return(1, 2):
      and_then(arena.at:should_be_called_with(1, 2):and_will_return('outside')):
      when(function()
        assert.is_false(line({ position = { x = 0.45, y = 0.6 } }, arena, robot))
      end)
  end)
end)
