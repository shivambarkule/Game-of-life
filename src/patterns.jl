"""
    Patterns Module

Provides predefined Game of Life patterns including oscillators, spaceships, and still lifes.
"""

# Pattern definitions as Matrix{Bool} where true = alive, false = dead

"""
Glider - A small spaceship that moves diagonally across the grid.
Period: 4, moves 1 cell diagonally every 4 generations.
"""
const GLIDER = Bool[
    0 1 0;
    0 0 1;
    1 1 1
]

"""
Blinker - The smallest oscillator, alternates between horizontal and vertical.
Period: 2
"""
const BLINKER = Bool[
    1 1 1
]

"""
Toad - A period-2 oscillator.
"""
const TOAD = Bool[
    0 1 1 1;
    1 1 1 0
]

"""
Beacon - A period-2 oscillator formed by two blocks.
"""
const BEACON = Bool[
    1 1 0 0;
    1 1 0 0;
    0 0 1 1;
    0 0 1 1
]

"""
Pulsar - A large period-3 oscillator with beautiful symmetry.
"""
const PULSAR = Bool[
    0 0 1 1 1 0 0 0 1 1 1 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0;
    1 0 0 0 0 1 0 1 0 0 0 0 1;
    1 0 0 0 0 1 0 1 0 0 0 0 1;
    1 0 0 0 0 1 0 1 0 0 0 0 1;
    0 0 1 1 1 0 0 0 1 1 1 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 1 1 1 0 0 0 1 1 1 0 0;
    1 0 0 0 0 1 0 1 0 0 0 0 1;
    1 0 0 0 0 1 0 1 0 0 0 0 1;
    1 0 0 0 0 1 0 1 0 0 0 0 1;
    0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 1 1 1 0 0 0 1 1 1 0 0
]

"""
Gosper Glider Gun - A pattern that generates gliders indefinitely.
Period: 30
"""
const GLIDER_GUN = Bool[
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1;
    0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 1 1;
    1 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    1 1 0 0 0 0 0 0 0 0 1 0 0 0 1 0 1 1 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
]

"""
    get_pattern(name::Symbol)::Matrix{Bool}

Retrieve a predefined pattern by name.

# Arguments
- `name::Symbol`: Pattern name (`:glider`, `:blinker`, `:toad`, `:beacon`, `:pulsar`, `:glider_gun`)

# Returns
- `Matrix{Bool}`: The pattern as a 2D boolean array

# Throws
- `ArgumentError`: If pattern name is not recognized

# Examples
```julia
glider = get_pattern(:glider)
blinker = get_pattern(:blinker)
```
"""
function get_pattern(name::Symbol)::Matrix{Bool}
    if name == :glider
        return GLIDER
    elseif name == :blinker
        return BLINKER
    elseif name == :toad
        return TOAD
    elseif name == :beacon
        return BEACON
    elseif name == :pulsar
        return PULSAR
    elseif name == :glider_gun
        return GLIDER_GUN
    else
        available = [:glider, :blinker, :toad, :beacon, :pulsar, :glider_gun]
        throw(ArgumentError("Unknown pattern: $name. Available patterns: $available"))
    end
end

"""
    place_pattern!(grid::Grid, pattern::Matrix{Bool}, row::Int, col::Int)

Place a pattern on the grid at the specified coordinates.

The top-left corner of the pattern will be placed at (row, col).
If the pattern extends beyond grid boundaries, it will be clipped.

# Arguments
- `grid::Grid`: The grid to modify
- `pattern::Matrix{Bool}`: The pattern to place
- `row::Int`: Starting row position (1-based)
- `col::Int`: Starting column position (1-based)

# Examples
```julia
grid = Grid(50, 50)
glider = get_pattern(:glider)
place_pattern!(grid, glider, 10, 10)  # Place glider at position (10, 10)
```
"""
function place_pattern!(grid::Grid, pattern::Matrix{Bool}, row::Int, col::Int)
    pattern_rows, pattern_cols = size(pattern)
    
    # Calculate valid ranges to handle boundary clipping
    # This allows patterns to be placed partially off-grid
    for i in 1:pattern_rows
        for j in 1:pattern_cols
            target_row = row + i - 1
            target_col = col + j - 1
            
            # Only place cells that are within grid bounds
            if target_row >= 1 && target_row <= grid.rows && 
               target_col >= 1 && target_col <= grid.cols
                grid.cells[target_row, target_col] = pattern[i, j]
            end
        end
    end
    
    return nothing
end
