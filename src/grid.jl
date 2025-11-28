"""
    Grid

Data structure representing the cellular automaton grid.

# Fields
- `cells::Matrix{Bool}`: 2D array where true = alive, false = dead
- `rows::Int`: Number of rows in the grid
- `cols::Int`: Number of columns in the grid
"""
struct Grid
    cells::Matrix{Bool}
    rows::Int
    cols::Int
end

"""
    Grid(rows::Int, cols::Int)

Create a new grid with specified dimensions. All cells are initialized to dead (false).

# Arguments
- `rows::Int`: Number of rows (must be between 10 and 500)
- `cols::Int`: Number of columns (must be between 10 and 500)

# Returns
- `Grid`: A new grid with all cells set to dead

# Throws
- `ArgumentError`: If dimensions are outside the valid range [10, 500]

# Examples
```julia
grid = Grid(50, 50)  # Create default 50x50 grid
grid = Grid(100, 100)  # Create larger 100x100 grid
```
"""
function Grid(rows::Int, cols::Int)
    # Validate dimensions (Requirements 1.2)
    if rows < 10 || rows > 500
        throw(ArgumentError("Grid rows must be between 10 and 500, got $rows"))
    end
    if cols < 10 || cols > 500
        throw(ArgumentError("Grid columns must be between 10 and 500, got $cols"))
    end
    
    # Initialize all cells to dead (Requirement 1.4)
    cells = falses(rows, cols)
    return Grid(cells, rows, cols)
end

"""
    Grid()

Create a grid with default dimensions of 50x50.

# Returns
- `Grid`: A new 50x50 grid with all cells set to dead

# Examples
```julia
grid = Grid()  # Creates a 50x50 grid
```
"""
Grid() = Grid(50, 50)  # Requirement 1.3

"""
    set_cell!(grid::Grid, row::Int, col::Int, alive::Bool)

Set the state of a specific cell in the grid.

# Arguments
- `grid::Grid`: The grid to modify
- `row::Int`: Row index (1-based)
- `col::Int`: Column index (1-based)
- `alive::Bool`: true for alive, false for dead

# Throws
- `BoundsError`: If row or col is outside grid dimensions

# Examples
```julia
grid = Grid(50, 50)
set_cell!(grid, 10, 10, true)  # Set cell at (10,10) to alive
set_cell!(grid, 10, 11, false)  # Set cell at (10,11) to dead
```
"""
function set_cell!(grid::Grid, row::Int, col::Int, alive::Bool)
    # Bounds checking (Requirement 2.1)
    if row < 1 || row > grid.rows || col < 1 || col > grid.cols
        throw(BoundsError(grid.cells, (row, col)))
    end
    grid.cells[row, col] = alive
    return nothing
end

"""
    get_cell(grid::Grid, row::Int, col::Int)::Bool

Get the state of a specific cell in the grid.

# Arguments
- `grid::Grid`: The grid to query
- `row::Int`: Row index (1-based)
- `col::Int`: Column index (1-based)

# Returns
- `Bool`: true if cell is alive, false if dead

# Throws
- `BoundsError`: If row or col is outside grid dimensions

# Examples
```julia
grid = Grid(50, 50)
set_cell!(grid, 10, 10, true)
alive = get_cell(grid, 10, 10)  # Returns true
```
"""
function get_cell(grid::Grid, row::Int, col::Int)::Bool
    # Bounds checking
    if row < 1 || row > grid.rows || col < 1 || col > grid.cols
        throw(BoundsError(grid.cells, (row, col)))
    end
    return grid.cells[row, col]
end

"""
    randomize!(grid::Grid, probability::Float64)

Randomly populate the grid with alive cells based on a probability.

# Arguments
- `grid::Grid`: The grid to populate
- `probability::Float64`: Probability (0.0 to 1.0) that each cell will be alive

# Throws
- `ArgumentError`: If probability is not between 0.0 and 1.0

# Examples
```julia
grid = Grid(50, 50)
randomize!(grid, 0.3)  # Approximately 30% of cells will be alive
```
"""
function randomize!(grid::Grid, probability::Float64)
    # Validate probability (Requirement 2.2)
    if probability < 0.0 || probability > 1.0
        throw(ArgumentError("Probability must be between 0.0 and 1.0, got $probability"))
    end
    
    # Randomly set cells based on probability
    for i in 1:grid.rows
        for j in 1:grid.cols
            grid.cells[i, j] = rand() < probability
        end
    end
    return nothing
end

"""
    clear!(grid::Grid)

Set all cells in the grid to dead (false).

# Arguments
- `grid::Grid`: The grid to clear

# Examples
```julia
grid = Grid(50, 50)
randomize!(grid, 0.3)
clear!(grid)  # All cells are now dead
```
"""
function clear!(grid::Grid)
    fill!(grid.cells, false)
    return nothing
end

"""
    copy_grid(grid::Grid)::Grid

Create a deep copy of a grid.

# Arguments
- `grid::Grid`: The grid to copy

# Returns
- `Grid`: A new grid with the same dimensions and cell states

# Examples
```julia
grid1 = Grid(50, 50)
randomize!(grid1, 0.3)
grid2 = copy_grid(grid1)  # grid2 is an independent copy
```
"""
function copy_grid(grid::Grid)::Grid
    return Grid(copy(grid.cells), grid.rows, grid.cols)
end
