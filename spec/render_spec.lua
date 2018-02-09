describe('render', function()
  local render = require 'render'

  it('should disallow even grid sizes', function()
    assert.has_error(function()
      render({ size = 2 })
    end, 'Grid size must be odd')
  end)

  it('should render a grid with size 1', function()
    local expected = [[
 ___
/   \
\___/
]]

    assert.are.equal(expected, render({ size = 1 }))
  end)

  it('should render a grid with size 3', function()
    local expected = [[
     ___
 ___/   \___
/   \___/   \
\___/   \___/
/   \___/   \
\___/   \___/
    \___/
]]

    assert.are.equal(expected, render({ size = 3 }))
  end)

  it('should render a grid with size 5', function()
    local expected = [[
         ___
     ___/   \___
 ___/   \___/   \___
/   \___/   \___/   \
\___/   \___/   \___/
/   \___/   \___/   \
\___/   \___/   \___/
/   \___/   \___/   \
\___/   \___/   \___/
    \___/   \___/
        \___/
]]

    assert.are.equal(expected, render({ size = 5 }))
  end)

  it('should allow robots to be rendered', function()
    local expected = [[
         ___
     ___/   \___
 ___/   \___/   \___
/   \___/ o \___/   \
\___/x  \___/  o\___/
/   \___/   \___/   \
\___/   \___/   \___/
/   \x__/   \__o/   \
\___/   \_x_/   \___/
    \___/   \___/
        \___/
]]

    assert.are.equal(expected, render({
      size = 5,
      robots = {
        { x = 2, y = 2, marker = 'o', heading = 'north' },
        { x = 3, y = 3, marker = 'o', heading = 'northeast' },
        { x = 3, y = 5, marker = 'o', heading = 'southeast' },
        { x = 2, y = 6, marker = 'x', heading = 'south' },
        { x = 1, y = 5, marker = 'x', heading = 'southwest' },
        { x = 1, y = 3, marker = 'x', heading = 'northwest' },
      }
    }))
  end)
end)
