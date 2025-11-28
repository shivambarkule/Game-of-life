"""
    Simulation

Manages the Game of Life simulation state and evolution.

# Fields
- `current_grid::Grid`: The current state of the grid
- `initial_grid::Grid`: Copy of the initial state for reset functionality
- `generation::Int`: Current generation number
"""
mutable struct Simulation
    current_grid::Grid
    initial_grid::Grid
    generation::Int
end

"""
    Simulation(grid::Grid)

Create a new simulation from a grid.

The initial grid state is stored for reset functionality.

# Arguments
- `grid::Grid`: The starting grid configuration

# Returns
- `Simulation`: A new simulation initialized at generation 0

# Examples
```julia
grid = Grid(50, 50)
randomize!(grid, 0.3)
sim = Simulation(grid)
```
"""
function Simulation(grid::Grid)
    return Simulation(grid, copy_grid(grid), 0)
end

"""
    count_neighbors(grid::Grid, row::Int, col::Int)::Int

Count the number of live neighbors for a cell using toroidal topology.

The grid wraps around at edges (toroidal topology), so cells on the edge
have neighbors on the opposite edge. All 8 adjacent cells are counted.

# Arguments
- `grid::Grid`: The grid to examine
- `row::Int`: Row index of the cell
- `col::Int`: Column index of the cell

# Returns
- `Int`: Number of live neighbors (0-8)

# Examples
```julia
grid = Grid(50, 50)
set_cell!(grid, 10, 10, true)
neighbors = count_neighbors(grid, 10, 11)  # Count neighbors of cell at (10, 11)
```
"""
function count_neighbors(grid::Grid, row::Int, col::Int)::Int
    count = 0
    
    # Check all 8 neighbors with toroidal wrapping
    for dr in -1:1
        for dc in -1:1
            # Skip the center cell
            if dr == 0 && dc == 0
                continue
            end
            
            # Calculate neighbor position with wrapping
            # Julia uses 1-based indexing, so we need to adjust
            neighbor_row = mod1(row + dr, grid.rows)
            neighbor_col = mod1(col + dc, grid.cols)
            
            if grid.cells[neighbor_row, neighbor_col]
                count += 1
            end
        end
    end
    
    return count
end

"""
    step!(sim::Simulation)

Advance the simulation by one generation according to Conway's Game of Life rules.

Rules:
1. Any live cell with fewer than 2 live neighbors dies (underpopulation)
2. Any live cell with 2 or 3 live neighbors survives
3. Any live cell with more than 3 live neighbors dies (overpopulation)
4. Any dead cell with exactly 3 live neighbors becomes alive (reproduction)

# Arguments
- `sim::Simulation`: The simulation to advance

# Examples
```julia
sim = Simulation(grid)
step!(sim)  # Advance by one generation
println("Generation: ", sim.generation)
```
"""
function step!(sim::Simulation)
    grid = sim.current_grid
    
    # Create new grid for next generation (double buffering)
    new_cells = similar(grid.cells)
    
    # Apply Game of Life rules to each cell
    for row in 1:grid.rows
        for col in 1:grid.cols
            neighbors = count_neighbors(grid, row, col)
            current_alive = grid.cells[row, col]
            
            # Apply Conway's rules
            if current_alive
                # Live cell rules (Requirements 3.1, 3.2, 3.3)
                if neighbors < 2
                    # Underpopulation
                    new_cells[row, col] = false
                elseif neighbors == 2 || neighbors == 3
                    # Survival
                    new_cells[row, col] = true
                else
                    # Overpopulation (neighbors > 3)
                    new_cells[row, col] = false
                end
            else
                # Dead cell rules (Requirement 3.4)
                if neighbors == 3
                    # Reproduction
                    new_cells[row, col] = true
                else
                    new_cells[row, col] = false
                end
            end
        end
    end
    
    # Update grid with new generation
    sim.current_grid = Grid(new_cells, grid.rows, grid.cols)
    sim.generation += 1
    
    return nothing
end

"""
    run!(sim::Simulation, steps::Int)

Run the simulation for a specified number of generations.

# Arguments
- `sim::Simulation`: The simulation to run
- `steps::Int`: Number of generations to compute

# Examples
```julia
sim = Simulation(grid)
run!(sim, 100)  # Run for 100 generations
println("Final generation: ", sim.generation)
```
"""
function run!(sim::Simulation, steps::Int)
    for _ in 1:steps
        step!(sim)
    end
    return nothing
end

"""
    reset!(sim::Simulation)

Reset the simulation to its initial state.

The grid is restored to the state it was in when the simulation was created,
and the generation counter is reset to 0.

# Arguments
- `sim::Simulation`: The simulation to reset

# Examples
```julia
sim = Simulation(grid)
run!(sim, 50)
reset!(sim)  # Back to generation 0 with initial grid
```
"""
function reset!(sim::Simulation)
    sim.current_grid = copy_grid(sim.initial_grid)
    sim.generation = 0
    return nothing
end
