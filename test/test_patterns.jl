using Test
using GameOfLife

@testset "Pattern Tests" begin
    
    @testset "Get Pattern" begin
        # Test all valid patterns
        glider = get_pattern(:glider)
        @test size(glider) == (3, 3)
        @test isa(glider, Matrix{Bool})
        
        blinker = get_pattern(:blinker)
        @test size(blinker) == (1, 3)
        
        toad = get_pattern(:toad)
        @test size(toad) == (2, 4)
        
        beacon = get_pattern(:beacon)
        @test size(beacon) == (4, 4)
        
        pulsar = get_pattern(:pulsar)
        @test size(pulsar) == (13, 13)
        
        glider_gun = get_pattern(:glider_gun)
        @test size(glider_gun) == (9, 36)
        
        # Test invalid pattern
        @test_throws ArgumentError get_pattern(:invalid_pattern)
    end
    
    @testset "Pattern Placement" begin
        grid = Grid(50, 50)
        
        # Place glider in the middle
        glider = get_pattern(:glider)
        place_pattern!(grid, glider, 20, 20)
        
        # Verify glider is placed correctly
        @test get_cell(grid, 20, 21) == true  # Top row: .O.
        @test get_cell(grid, 21, 22) == true  # Middle row: ..O
        @test get_cell(grid, 22, 20) == true  # Bottom row: OOO
        @test get_cell(grid, 22, 21) == true
        @test get_cell(grid, 22, 22) == true
        
        # Test placement at grid edges (should clip gracefully)
        grid2 = Grid(50, 50)
        place_pattern!(grid2, glider, 1, 1)  # Top-left corner
        @test get_cell(grid2, 1, 2) == true
        
        grid3 = Grid(50, 50)
        place_pattern!(grid3, glider, 49, 49)  # Near bottom-right (will clip)
        # Should not throw error, just clip the pattern
        @test true  # If we got here, no error was thrown
    end
    
    @testset "Pattern Content Verification" begin
        # Verify glider pattern structure
        glider = get_pattern(:glider)
        expected_glider = Bool[
            0 1 0;
            0 0 1;
            1 1 1
        ]
        @test glider == expected_glider
        
        # Verify blinker pattern
        blinker = get_pattern(:blinker)
        expected_blinker = Bool[1 1 1]
        @test blinker == expected_blinker
    end
    
    @testset "Multiple Pattern Placement" begin
        grid = Grid(100, 100)
        
        # Place multiple patterns on the same grid
        place_pattern!(grid, get_pattern(:glider), 10, 10)
        place_pattern!(grid, get_pattern(:blinker), 30, 30)
        place_pattern!(grid, get_pattern(:toad), 50, 50)
        
        # Verify all patterns are present
        @test get_cell(grid, 10, 11) == true  # Glider
        @test get_cell(grid, 30, 30) == true  # Blinker
        # Toad pattern at (50, 50) - first row is [0 1 1 1]
        @test get_cell(grid, 50, 50) == false  # Toad first cell (0)
        @test get_cell(grid, 50, 51) == true   # Toad second cell (1)
    end
    
end
