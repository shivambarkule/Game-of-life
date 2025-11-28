"""
    Game Logic Module

Implements core Game of Life rules, enemy spawning, collision detection, and scoring.
"""

# Pattern definitions
const GLIDER = Bool[
    0 1 0;
    0 0 1;
    1 1 1
]

const BLINKER = Bool[1 1 1]

const TOAD = Bool[
    0 1 1 1;
    1 1 1 0
]

"""
    count_neighbors(grid::Matrix{Bool}, row::Int, col::Int)::Int

Count live neighbors for a cell using toroidal wrapping.
"""
function count_neighbors(grid::Matrix{Bool}, row::Int, col::Int)::Int
    rows, cols = size(grid)
    count = 0
    
    for dr in -1:1
        for dc in -1:1
            if dr == 0 && dc == 0
                continue
            end
            
            neighbor_row = mod1(row + dr, rows)
            neighbor_col = mod1(col + dc, cols)
            
            if grid[neighbor_row, neighbor_col]
                count += 1
            end
        end
    end
    
    return count
end

"""
    apply_game_of_life_rules(grid::Matrix{Bool})::Matrix{Bool}

Apply Conway's Game of Life rules to the grid.
"""
function apply_game_of_life_rules(grid::Matrix{Bool})::Matrix{Bool}
    rows, cols = size(grid)
    new_grid = similar(grid)
    
    for row in 1:rows
        for col in 1:cols
            neighbors = count_neighbors(grid, row, col)
            current_alive = grid[row, col]
            
            if current_alive
                # Live cell rules
                if neighbors < 2 || neighbors > 3
                    new_grid[row, col] = false
                else
                    new_grid[row, col] = true
                end
            else
                # Dead cell rules
                if neighbors == 3
                    new_grid[row, col] = true
                else
                    new_grid[row, col] = false
                end
            end
        end
    end
    
    return new_grid
end

"""
    get_pattern(name::String)::Matrix{Bool}

Get a pattern by name.
"""
function get_pattern(name::String)::Matrix{Bool}
    if name == "glider"
        return GLIDER
    elseif name == "blinker"
        return BLINKER
    elseif name == "toad"
        return TOAD
    else
        error("Unknown pattern: $name")
    end
end

"""
    spawn_enemy(session::GameSession)::Bool

Spawn a random enemy pattern on the left edge.
Returns true if spawn was successful.
"""
function spawn_enemy(session::GameSession)::Bool
    # Random pattern selection
    patterns = ["glider", "blinker", "toad"]
    pattern_name = rand(patterns)
    pattern = get_pattern(pattern_name)
    
    # Random spawn position on left edge (columns 1-10)
    spawn_col = rand(1:10)
    spawn_row = rand(1:(200 - size(pattern, 1) + 1))
    
    # Place pattern on grid
    try
        place_pattern_on_grid!(session.grid, pattern, spawn_row, spawn_col)
        return true
    catch
        return false
    end
end

"""
    place_pattern_on_grid!(grid::Matrix{Bool}, pattern::Matrix{Bool}, row::Int, col::Int)

Place a pattern on the grid at the specified position.
"""
function place_pattern_on_grid!(grid::Matrix{Bool}, pattern::Matrix{Bool}, row::Int, col::Int)
    pattern_rows, pattern_cols = size(pattern)
    
    for i in 1:pattern_rows
        for j in 1:pattern_cols
            target_row = row + i - 1
            target_col = col + j - 1
            
            if target_row >= 1 && target_row <= size(grid, 1) &&
               target_col >= 1 && target_col <= size(grid, 2)
                grid[target_row, target_col] = pattern[i, j]
            end
        end
    end
end

"""
    detect_collisions(grid::Matrix{Bool})::Int

Detect collisions between enemy and player patterns.
Returns number of collisions detected.
"""
function detect_collisions(grid::Matrix{Bool})::Int
    collisions = 0
    
    # Check for alive cells in both zones that are adjacent
    for row in 1:200
        for col in 2:199
            if grid[row, col]
                # Check if this cell has neighbors in opposite zone
                left_alive = col > 1 && grid[row, col - 1]
                right_alive = col < 200 && grid[row, col + 1]
                
                # If cell is in enemy zone and has right neighbor, or vice versa
                if (is_in_enemy_zone(row, col) && right_alive) ||
                   (is_in_player_zone(row, col) && left_alive)
                    collisions += 1
                end
            end
        end
    end
    
    return collisions
end

"""
    remove_escaped_patterns(session::GameSession)::Int

Remove patterns that have escaped to the right edge.
Returns number of escaped patterns.
"""
function remove_escaped_patterns(session::GameSession)::Int
    escaped = 0
    
    # Check right edge (column 200)
    for row in 1:200
        if session.grid[row, 200]
            session.grid[row, 200] = false
            escaped += 1
        end
    end
    
    return escaped
end

"""
    step_game!(session::GameSession)::Dict

Advance the game by one generation.
Returns a dictionary with step results.
"""
function step_game!(session::GameSession)::Dict
    if session.paused || session.game_over
        return Dict("success" => false, "reason" => "Game is paused or over")
    end
    
    # Apply Game of Life rules
    session.grid = apply_game_of_life_rules(session.grid)
    session.generation += 1
    
    # Spawn enemies at intervals
    wave = get_wave(session.patterns_destroyed)
    session.spawn_interval = calculate_spawn_interval(wave - 1, session.difficulty)
    
    if session.generation - session.last_spawn >= session.spawn_interval
        spawn_enemy(session)
        session.last_spawn = session.generation
    end
    
    # Detect collisions
    collisions = detect_collisions(session.grid)
    if collisions > 0
        session.patterns_destroyed += collisions
        session.score += collisions * 10
    end
    
    # Remove escaped patterns
    escaped = remove_escaped_patterns(session)
    session.enemies_escaped += escaped
    session.score = max(0, session.score - escaped * 5)
    
    # Check game over condition
    if session.enemies_escaped >= 5
        session.game_over = true
    end
    
    session.last_updated = now()
    
    return Dict(
        "success" => true,
        "generation" => session.generation,
        "score" => session.score,
        "collisions" => collisions,
        "escaped" => escaped
    )
end
