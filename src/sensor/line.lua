return function(config, arena, robot)
  return arena.at(robot.point_at(config.position.x, config.position.y)) == 'line'
end
