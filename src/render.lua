local function trim_right(s)
  return (s:match('(.-)%s*$'))
end

local function generate_empty_grid(size)
  local width = size * 4 + 1
  local height = size * 2 + 1
  local grid = {}
  for i = 1, height do
    local row = {}
    for i = 1, width do
      table.insert(row, ' ')
    end
    table.insert(grid, row)
  end
  return grid
end

local function grid_to_string(grid)
  for i, row in ipairs(grid) do
    grid[i] = trim_right(table.concat(row, ''))
  end
  return table.concat(grid, '\n') .. '\n'
end

return function(state)
  assert(state.size % 2 == 1, 'Grid size must be odd')

  local size = state.size
  local robots = state.robots or {}
  local grid = generate_empty_grid(size)

  local function render_hex(x, y)
    y = (y * 1) + 1
    x = (x * 4) + 1

    grid[y + 0][x + 1] = '_'
    grid[y + 0][x + 2] = '_'
    grid[y + 0][x + 3] = '_'

    grid[y + 1][x + 0] = '/'
    grid[y + 1][x + 4] = '\\'

    grid[y + 2][x + 0] = '\\'
    grid[y + 2][x + 1] = '_'
    grid[y + 2][x + 2] = '_'
    grid[y + 2][x + 3] = '_'
    grid[y + 2][x + 4] = '/'
  end

  local function render_robot(robot)
    local heading_offset = {
      north = { dx = 3, dy = 2 },
      northeast = { dx = 4, dy = 2 },
      southeast = { dx = 4, dy = 3 },
      south = { dx = 3, dy = 3 },
      southwest = { dx = 2, dy = 3 },
      northwest = { dx = 2, dy = 2 }
    }
    local x = (robot.position.x * 4) + heading_offset[robot.heading].dx
    local y = (robot.position.y * 1) + heading_offset[robot.heading].dy

    grid[y][x] = robot.marker
  end

  for i = 0, math.ceil(size / 2) - 1 do
    local x = math.floor(size / 2)
    local y = size - (2 * i) - 1
    render_hex(x, y)

    local deltas = { { 1, 1 }, { 0, 2 }, { -1, 1 }, { -1, -1 }, { 0, -2 }, { 1, -1 } }
    for _, delta in ipairs(deltas) do
      local dx, dy = table.unpack(delta)
      for j = 1, i do
        x = x + dx
        y = y + dy
        render_hex(x, y)
      end
    end
  end

  for _, robot in ipairs(robots) do
    render_robot(robot)
  end

  return grid_to_string(grid)
end
