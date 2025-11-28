using Test
using GameOfLife

@testset "Simulation Tests" begin
    
    @testset "Simulation Construction" begin
        grid = Grid(50, 50)
        randomize!(grid, 0.3)
        
        sim = Simulation(grid)
        @test sim.generation == 0
        @test sim.current_grid.rows == 50
        @test sim.current_grid.cols == 50
        
        # Initial grid should be stored for reset
        @test sim.initial_grid.cells == grid.cells
    end
    
    @testset "Neighbor Counting" begin
        grid = Grid(50, 50)
        
        # Test with single cell
        set_cell!(grid, 25, 25, true)
        @test count_neighbors(grid, 25, 25) == 0
        @test count_neighbors(grid, 24, 24) == 1
        @test count_neighbors(grid, 24, 25) == 1
        @test count_neighbors(grid, 24, 26) == 1
        @test count_neighbors(grid, 25, 24) == 1
        @test count_neighbors(grid, 25, 26) == 1
        @test count_neighbors(grid, 26, 24) == 1
        @test count_neighbors(grid, 26, 25) == 1
        @test count_neighbors(grid, 26, 26) == 1
        
        # Test with multiple cells
        clear!(grid)
        set_cell!(grid, 25, 25, true)
        set_cell!(grid, 25, 26, true)
        set_cell!(grid, 25, 27, true)
        @test count_neighbors(grid, 25, 26) == 2  # Middle cell has 2 neighbors
        @test count_neighbors(grid, 24, 26) == 3  # Cell above has 3 neighbors
        
        # Test toroidal wrapping (edges)
        clear!(grid)
        set_cell!(grid, 1, 1, true)
        # Corner cell should have neighbors wrapping around
        neighbors = count_neighbors(grid, 50, 50)
        @test neighbors == 1  # The cell at (1,1) wraps to be a neighbor
    end
    
    @testset "Game of Life Rules" begin
        # Rule 1: Underpopulation (< 2 neighbors)
        grid = Grid(50, 50)
        set_cell!(grid, 25, 25, true)
        set_cell!(grid, 25, 26, true)
        sim = Simulation(grid)
        step!(sim)
        # Both cells should die (each has only 1 neighbor)
        @test get_cell(sim.current_grid, 25, 25) == false
        @test get_cell(sim.current_grid, 25, 26) == false
        
        # Rule 2: Survival (2-3 neighbors)
        grid = Grid(50, 50)
        # Create a block (2x2 square) - stable pattern
        set_cell!(grid, 25, 25, true)
        set_cell!(grid, 25, 26, true)
        set_cell!(grid, 26, 25, true)
        set_cell!(grid, 26, 26, true)
        sim = Simulation(grid)
        step!(sim)
        # All cells should survive (each has 3 neighbors)
        @test get_cell(sim.current_grid, 25, 25) == true
        @test get_cell(sim.current_grid, 25, 26) == true
        @test get_cell(sim.current_grid, 26, 25) == true
        @test get_cell(sim.current_grid, 26, 26) == true
        
        # Rule 3: Overpopulation (> 3 neighbors)
        grid = Grid(50, 50)
        # Create a pattern where center cell has 4 neighbors
        set_cell!(grid, 25, 25, true)  # Center
        set_cell!(grid, 24, 25, true)  # Top
        set_cell!(grid, 26, 25, true)  # Bottom
        set_cell!(grid, 25, 24, true)  # Left
        set_cell!(grid, 25, 26, true)  # Right
        sim = Simulation(grid)
        step!(sim)
        # Center cell should die from overpopulation
        @test get_cell(sim.current_grid, 25, 25) == false
        
        # Rule 4: Reproduction (exactly 3 neighbors)
        grid = Grid(50, 50)
        # Create blinker pattern
        set_cell!(grid, 25, 24, true)
        set_cell!(grid, 25, 25, true)
        set_cell!(grid, 25, 26, true)
        sim = Simulation(grid)
        step!(sim)
        # Cell above and below middle should be born
        @test get_cell(sim.current_grid, 24, 25) == true
        @test get_cell(sim.current_grid, 26, 25) == true
    end
    
    @testset "Known Patterns" begin
        # Test blinker oscillator (period 2)
        grid = Grid(50, 50)
        place_pattern!(grid, get_pattern(:blinker), 25, 24)
        sim = Simulation(grid)
        
        # Store initial state
        initial_state = copy_grid(sim.current_grid)
        
        # After 1 step, should be different
        step!(sim)
        @test sim.current_grid.cells != initial_state.cells
        
        # After 2 steps, should return to initial state
        step!(sim)
        @test sim.current_grid.cells == initial_state.cells
        
        # Test block (still life - should not change)
        grid = Grid(50, 50)
        set_cell!(grid, 25, 25, true)
        set_cell!(grid, 25, 26, true)
        set_cell!(grid, 26, 25, true)
        set_cell!(grid, 26, 26, true)
        sim = Simulation(grid)
        
        initial_state = copy_grid(sim.current_grid)
        step!(sim)
        @test sim.current_grid.cells == initial_state.cells
    end
    
    @testset "Step and Run" begin
        grid = Grid(50, 50)
        randomize!(grid, 0.3)
        sim = Simulation(grid)
        
        # Test single step
        @test sim.generation == 0
        step!(sim)
        @test sim.generation == 1
        
        # Test run multiple steps
        run!(sim, 10)
        @test sim.generation == 11
    end
    
    @testset "Reset" begin
        grid = Grid(50, 50)
        randomize!(grid, 0.3)
        sim = Simulation(grid)
        
        initial_cells = copy(sim.current_grid.cells)
        
        # Run simulation
        run!(sim, 20)
        @test sim.generation == 20
        @test sim.current_grid.cells != initial_cells
        
        # Reset
        reset!(sim)
        @test sim.generation == 0
        @test sim.current_grid.cells == initial_cells
    end
    
    @testset "Performance" begin
        # Test that 100x100 grid computes in < 100ms
        grid = Grid(100, 100)
        randomize!(grid, 0.3)
        sim = Simulation(grid)
        
        # Measure time for single generation
        elapsed = @elapsed step!(sim)
        @test elapsed < 0.1  # Should be less than 100ms
    end
    
end
