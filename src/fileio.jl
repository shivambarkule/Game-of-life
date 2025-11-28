"""
    File I/O Module

Provides functionality to save and load Game of Life grid configurations.
"""

"""
    save_grid(grid::Grid, filename::String)

Save a grid configuration to a text file.

The file format includes metadata (rows, cols) followed by the grid pattern
where 'O' represents alive cells and '.' represents dead cells.

# Arguments
- `grid::Grid`: The grid to save
- `filename::String`: Path to the output file

# Examples
```julia
grid = Grid(50, 50)
place_pattern!(grid, get_pattern(:glider), 10, 10)
save_grid(grid, "my_pattern.txt")
```
"""
function save_grid(grid::Grid, filename::String)
    try
        open(filename, "w") do file
            # Write header with metadata
            println(file, "# Game of Life Pattern")
            println(file, "# Rows: $(grid.rows)")
            println(file, "# Cols: $(grid.cols)")
            println(file, "")
            
            # Write grid data
            for row in 1:grid.rows
                line = ""
                for col in 1:grid.cols
                    line *= grid.cells[row, col] ? "O" : "."
                end
                println(file, line)
            end
        end
        println("Grid saved to $filename")
    catch e
        error("Failed to save grid to $filename: $e")
    end
    
    return nothing
end

"""
    load_grid(filename::String)::Grid

Load a grid configuration from a file.

Reads a file in the format created by save_grid and reconstructs the Grid.

# Arguments
- `filename::String`: Path to the input file

# Returns
- `Grid`: The loaded grid

# Throws
- `ErrorException`: If file format is invalid or file cannot be read

# Examples
```julia
grid = load_grid("my_pattern.txt")
sim = Simulation(grid)
```
"""
function load_grid(filename::String)::Grid
    if !isfile(filename)
        error("File not found: $filename")
    end
    
    try
        rows = 0
        cols = 0
        lines = String[]
        
        # Read file and parse metadata
        open(filename, "r") do file
            for line in eachline(file)
                line = strip(line)
                
                # Skip empty lines
                if isempty(line)
                    continue
                end
                
                # Parse metadata
                if startswith(line, "# Rows:")
                    rows = parse(Int, split(line, ":")[2])
                elseif startswith(line, "# Cols:")
                    cols = parse(Int, split(line, ":")[2])
                elseif startswith(line, "#")
                    # Skip other comments
                    continue
                else
                    # This is grid data
                    push!(lines, line)
                end
            end
        end
        
        # Validate metadata
        if rows == 0 || cols == 0
            error("Invalid file format: missing or invalid dimensions")
        end
        
        # Validate grid data
        if length(lines) != rows
            error("Invalid file format: expected $rows rows, got $(length(lines))")
        end
        
        # Create grid and populate cells
        grid = Grid(rows, cols)
        
        for (i, line) in enumerate(lines)
            if length(line) != cols
                error("Invalid file format: row $i has $(length(line)) columns, expected $cols")
            end
            
            for (j, char) in enumerate(line)
                if char == 'O' || char == 'o'
                    grid.cells[i, j] = true
                elseif char == '.' || char == ' '
                    grid.cells[i, j] = false
                else
                    error("Invalid character '$char' at row $i, col $j. Use 'O' for alive or '.' for dead")
                end
            end
        end
        
        println("Grid loaded from $filename")
        return grid
        
    catch e
        error("Failed to load grid from $filename: $e")
    end
end

"""
    validate_file(filename::String)::Bool

Check if a file is a valid Game of Life pattern file.

# Arguments
- `filename::String`: Path to the file to validate

# Returns
- `Bool`: true if file is valid, false otherwise

# Examples
```julia
if validate_file("pattern.txt")
    grid = load_grid("pattern.txt")
end
```
"""
function validate_file(filename::String)::Bool
    if !isfile(filename)
        return false
    end
    
    try
        # Try to load the grid
        load_grid(filename)
        return true
    catch
        return false
    end
end
