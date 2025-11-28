using Test
using GameOfLife

@testset "File I/O Tests" begin
    
    @testset "Save and Load Grid" begin
        # Create a test grid with a pattern
        grid = Grid(30, 30)
        place_pattern!(grid, get_pattern(:glider), 10, 10)
        
        # Save to file
        filename = "test_pattern.txt"
        save_grid(grid, filename)
        @test isfile(filename)
        
        # Load from file
        loaded_grid = load_grid(filename)
        
        # Verify dimensions
        @test loaded_grid.rows == grid.rows
        @test loaded_grid.cols == grid.cols
        
        # Verify content
        @test loaded_grid.cells == grid.cells
        
        # Clean up
        rm(filename)
    end
    
    @testset "File Format" begin
        grid = Grid(10, 10)
        set_cell!(grid, 5, 5, true)
        set_cell!(grid, 5, 6, true)
        
        filename = "test_format.txt"
        save_grid(grid, filename)
        
        # Read file and check format
        content = read(filename, String)
        @test occursin("# Game of Life Pattern", content)
        @test occursin("# Rows: 10", content)
        @test occursin("# Cols: 10", content)
        @test occursin("O", content)  # Should have alive cells
        @test occursin(".", content)  # Should have dead cells
        
        # Clean up
        rm(filename)
    end
    
    @testset "Load Invalid Files" begin
        # Test non-existent file
        @test_throws ErrorException load_grid("nonexistent.txt")
        
        # Test file with invalid format
        invalid_file = "invalid.txt"
        open(invalid_file, "w") do f
            println(f, "This is not a valid pattern file")
        end
        @test_throws ErrorException load_grid(invalid_file)
        rm(invalid_file)
        
        # Test file with missing dimensions
        missing_dims = "missing_dims.txt"
        open(missing_dims, "w") do f
            println(f, "# Game of Life Pattern")
            println(f, "OOO")
        end
        @test_throws ErrorException load_grid(missing_dims)
        rm(missing_dims)
        
        # Test file with mismatched dimensions
        mismatched = "mismatched.txt"
        open(mismatched, "w") do f
            println(f, "# Rows: 3")
            println(f, "# Cols: 3")
            println(f, "OOO")
            println(f, "OOO")
            # Only 2 rows instead of 3
        end
        @test_throws ErrorException load_grid(mismatched)
        rm(mismatched)
    end
    
    @testset "Validate File" begin
        # Create valid file
        grid = Grid(20, 20)
        randomize!(grid, 0.3)
        valid_file = "valid.txt"
        save_grid(grid, valid_file)
        
        @test validate_file(valid_file) == true
        rm(valid_file)
        
        # Test invalid file
        @test validate_file("nonexistent.txt") == false
        
        invalid_file = "invalid2.txt"
        open(invalid_file, "w") do f
            println(f, "Invalid content")
        end
        @test validate_file(invalid_file) == false
        rm(invalid_file)
    end
    
    @testset "Round Trip" begin
        # Test that save/load preserves all patterns
        patterns = [:glider, :blinker, :toad, :beacon]
        
        for pattern_name in patterns
            grid = Grid(50, 50)
            place_pattern!(grid, get_pattern(pattern_name), 20, 20)
            
            filename = "test_$(pattern_name).txt"
            save_grid(grid, filename)
            loaded_grid = load_grid(filename)
            
            @test loaded_grid.cells == grid.cells
            
            rm(filename)
        end
    end
    
    @testset "Large Grid Save/Load" begin
        # Test with maximum size grid
        grid = Grid(100, 100)
        randomize!(grid, 0.2)
        
        filename = "large_grid.txt"
        save_grid(grid, filename)
        loaded_grid = load_grid(filename)
        
        @test loaded_grid.rows == 100
        @test loaded_grid.cols == 100
        @test loaded_grid.cells == grid.cells
        
        rm(filename)
    end
    
    @testset "Special Characters in Filename" begin
        grid = Grid(20, 20)
        randomize!(grid, 0.3)
        
        # Test with spaces and special characters
        filename = "test pattern 123.txt"
        save_grid(grid, filename)
        @test isfile(filename)
        
        loaded_grid = load_grid(filename)
        @test loaded_grid.cells == grid.cells
        
        rm(filename)
    end
    
end
