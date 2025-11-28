"""
    GameOfLifeAPI

A Julia backend API for the Game of Life web game.
Provides REST endpoints for game simulation, enemy spawning, collision detection, and scoring.
"""
module GameOfLifeAPI

using HTTP
using JSON

# Include submodules
include("game_session.jl")
include("game_logic.jl")
include("api.jl")

# Export main functions
export GameSession, create_game, get_game_state, place_pattern, step_game, pause_game, restart_game, set_speed, start_server

end # module
