"""
    GameSession

Represents an active game session with all state information.
"""

using Dates
using UUIDs
using Random

mutable struct GameSession
    id::String
    grid::Matrix{Bool}  # 200x200 grid
    score::Int
    generation::Int
    paused::Bool
    speed::String  # "slow", "normal", "fast"
    patterns_destroyed::Int
    enemies_escaped::Int
    game_over::Bool
    difficulty::String
    last_spawn::Int  # Generation of last enemy spawn
    spawn_interval::Int  # Generations between spawns
    created_at::DateTime
    last_updated::DateTime
end

"""
    GameSession(difficulty::String="normal")

Create a new game session with a 200x200 grid.
"""
function GameSession(difficulty::String="normal")
    grid = rand(Bool, 200, 200)
    println("DEBUG: Created grid with $(sum(grid)) live cells")
    return GameSession(
        string(uuid4()),
        grid,
        0,
        0,
        false,
        "normal",
        0,
        0,
        false,
        difficulty,
        0,
        calculate_spawn_interval(0, difficulty),
        now(),
        now()
    )
end

"""
    calculate_spawn_interval(wave::Int, difficulty::String)::Int

Calculate spawn interval based on wave number and difficulty.
"""
function calculate_spawn_interval(wave::Int, difficulty::String)::Int
    base_interval = if difficulty == "easy"
        20
    elseif difficulty == "hard"
        8
    else  # normal
        15
    end
    
    # Decrease interval as waves progress
    wave_factor = max(1, 5 - div(wave, 3))
    return max(5, base_interval - wave_factor)
end

"""
    get_wave(patterns_destroyed::Int)::Int

Calculate current wave based on patterns destroyed.
"""
function get_wave(patterns_destroyed::Int)::Int
    return div(patterns_destroyed, 5) + 1
end

"""
    is_in_enemy_zone(row::Int, col::Int)::Bool

Check if position is in enemy zone (left half, columns 1-100).
"""
function is_in_enemy_zone(row::Int, col::Int)::Bool
    return 1 <= row <= 200 && 1 <= col <= 100
end

"""
    is_in_player_zone(row::Int, col::Int)::Bool

Check if position is in player zone (right half, columns 101-200).
"""
function is_in_player_zone(row::Int, col::Int)::Bool
    return 1 <= row <= 200 && 101 <= col <= 200
end

"""
    is_valid_placement(row::Int, col::Int, pattern_height::Int, pattern_width::Int)::Bool

Check if pattern can be placed at given position in player zone.
"""
function is_valid_placement(row::Int, col::Int, pattern_height::Int, pattern_width::Int)::Bool
    # Check if top-left corner is in player zone
    if !is_in_player_zone(row, col)
        return false
    end
    
    # Check if entire pattern fits within grid
    if row + pattern_height - 1 > 200 || col + pattern_width - 1 > 200
        return false
    end
    
    # Check if entire pattern is in player zone
    for r in row:(row + pattern_height - 1)
        for c in col:(col + pattern_width - 1)
            if !is_in_player_zone(r, c)
                return false
            end
        end
    end
    
    return true
end

"""
    grid_to_json(grid::Matrix{Bool})::Vector{Vector{Int}}

Convert grid to JSON-serializable format (0s and 1s).
"""
function grid_to_json(grid::Matrix{Bool})::Vector{Vector{Int}}
    return [[Int(grid[i, j]) for j in 1:size(grid, 2)] for i in 1:size(grid, 1)]
end

"""
    session_to_json(session::GameSession)::Dict

Convert game session to JSON-serializable dictionary.
"""
function session_to_json(session::GameSession)::Dict
    wave = get_wave(session.patterns_destroyed)
    return Dict(
        "gameId" => session.id,
        "grid" => grid_to_json(session.grid),
        "score" => session.score,
        "generation" => session.generation,
        "paused" => session.paused,
        "speed" => session.speed,
        "gameOver" => session.game_over,
        "stats" => Dict(
            "patternsDestroyed" => session.patterns_destroyed,
            "enemiesEscaped" => session.enemies_escaped,
            "wave" => wave
        )
    )
end
