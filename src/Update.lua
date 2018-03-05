return function(arena, sensor)
  return function(ai, this_robot, that_robot, dt)
    local inputs = {}
    for _, config in ipairs(ai.sensors) do
      inputs[config.name] = sensor[config.type](config, arena, this_robot, that_robot)
    end
    return ai.update(dt, inputs)
  end
end
