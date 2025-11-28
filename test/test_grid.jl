using Test
using GameOfLife

@testset "Grid Tests" begin
    
    @testset "Grid Construction" begin
        # Test default constructor
        grid = Grid()
        @test grid.rows == 50
        @test grid.cols == 50
        @test all(.!grid.cells)  # All cells should be dead
        
        # Test custom dimensions
        grid = Grid(100, 100)
        @test grid.rows == 100
        @test grid.cols == 100
        
        # Test minimum dimensions
        grid = Grid(10, 10)
        @test grid.rows == 10
        @test grid.cols == 10
        
        # Test maximum dimensions
        grid = Grid(500, 500)
        @test grid.rows == 500
        @test grid.cols == 500
        
        # Test invalid dimensions
        @test_throws ArgumentError Grid(5, 50)   # Too small
        @test_throws ArgumentError Grid(50, 5)   # Too small
        @test_throws ArgumentError Grid(600, 50) # Too large
        @test_throws ArgumentError Grid(50, 600) # Too large
    end
    
    @testset "Cell Operations" begin
        grid = Grid(50, 50)
        
        # Test set_cell! and get_cell
        @test get_cell(grid, 25, 25) == false
        set_cell!(grid, 25, 25, true)
        @test get_cell(grid, 25, 25) == true
        set_cell!(grid, 25, 25, false)
        @test get_cell(grid, 25, 25) == false
        
        # Test bounds checking
        @test_throws BoundsError set_cell!(grid, 0, 25, true)
        @test_throws BoundsError set_cell!(grid, 51, 25, true)
        @test_throws BoundsError set_cell!(grid, 25, 0, true)
        @test_throws BoundsError set_cell!(grid, 25, 51, true)
        
        @test_throws BoundsError get_cell(grid, 0, 25)
        @test_throws BoundsError get_cell(grid, 51, 25)
        @test_throws BoundsError get_cell(grid, 25, 0)
        @test_throws BoundsError get_cell(grid, 25, 51)
    end
    
    @testset "Randomization" begin
        grid = Grid(50, 50)
        
        # Test with 0% probability
        randomize!(grid, 0.0)
        @test all(.!grid.cells)
        
        # Test with 100% probability
        randomize!(grid, 1.0)
        @test all(grid.cells)
        
        # Test with 50% probability (statistical test)
        randomize!(grid, 0.5)
        alive_count = sum(grid.cells)
        total_cells = grid.rows * grid.cols
        # Should be roughly 50% ± 10% (allowing for randomness)
        @test alive_count > total_cells * 0.4
        @test alive_count < total_cells * 0.6
        
        # Test invalid probabilities
        @test_throws ArgumentError randomize!(grid, -0.1)
        @test_throws ArgumentError randomize!(grid, 1.1)
    end
    
    @testset "Clear Operation" begin
        grid = Grid(50, 50)
        randomize!(grid, 0.5)
        @test any(grid.cells)  # Some cells should be alive
        
        clear!(grid)
        @test all(.!grid.cells)  # All cells should be dead
    end
    
    @testset "Copy Grid" begin
        grid1 = Grid(30, 30)
        randomize!(grid1, 0.3)
        
        grid2 = copy_grid(grid1)
        
        # Grids should have same dimensions and content
        @test grid2.rows == grid1.rows
        @test grid2.cols == grid1.cols
        @test grid2.cells == grid1.cells
        
        # But should be independent (deep copy)
        set_cell!(grid1, 15, 15, true)
        @test grid1.cells[15, 15] != grid2.cells[15, 15]
    end
    
end
