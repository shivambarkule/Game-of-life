"""
    API Module

REST API endpoints for the Game of Life web game.
"""

# Global session storage
const SESSIONS = Dict{String, GameSession}()

"""
    create_game(difficulty::String="normal")::Dict

Create a new game session.
"""
function create_game(difficulty::String="normal")::Dict
    session = GameSession(difficulty)
    SESSIONS[session.id] = session
    return session_to_json(session)
end

"""
    get_game_state(game_id::String)::Dict

Get the current state of a game session.
"""
function get_game_state(game_id::String)::Dict
    if !haskey(SESSIONS, game_id)
        error("Game not found: $game_id")
    end
    
    session = SESSIONS[game_id]
    return session_to_json(session)
end

"""
    place_pattern(game_id::String, pattern_name::String, row::Int, col::Int)::Dict

Place a defensive pattern on the player zone.
"""
function place_pattern(game_id::String, pattern_name::String, row::Int, col::Int)::Dict
    if !haskey(SESSIONS, game_id)
        return Dict("success" => false, "error" => "Game not found")
    end
    
    session = SESSIONS[game_id]
    
    # Validate pattern name
    valid_patterns = ["glider", "blinker", "toad", "beacon"]
    if !(pattern_name in valid_patterns)
        return Dict("success" => false, "error" => "Invalid pattern: $pattern_name")
    end
    
    # Get pattern
    try
        pattern = get_pattern(pattern_name)
    catch
        return Dict("success" => false, "error" => "Pattern not found: $pattern_name")
    end
    
    # Validate placement
    pattern_height, pattern_width = size(pattern)
    if !is_valid_placement(row, col, pattern_height, pattern_width)
        return Dict("success" => false, "error" => "Invalid placement position")
    end
    
    # Place pattern
    try
        place_pattern_on_grid!(session.grid, pattern, row, col)
        session.last_updated = now()
        return Dict(
            "success" => true,
            "message" => "Pattern placed successfully",
            "grid" => grid_to_json(session.grid)
        )
    catch e
        return Dict("success" => false, "error" => string(e))
    end
end

"""
    step_game(game_id::String)::Dict

Advance the game by one generation.
"""
function step_game(game_id::String)::Dict
    if !haskey(SESSIONS, game_id)
        return Dict("success" => false, "error" => "Game not found")
    end
    
    session = SESSIONS[game_id]
    result = step_game!(session)
    
    if result["success"]
        return merge(result, Dict("grid" => grid_to_json(session.grid)))
    else
        return result
    end
end

"""
    pause_game(game_id::String, paused::Bool)::Dict

Pause or resume a game.
"""
function pause_game(game_id::String, paused::Bool)::Dict
    if !haskey(SESSIONS, game_id)
        return Dict("success" => false, "error" => "Game not found")
    end
    
    session = SESSIONS[game_id]
    session.paused = paused
    session.last_updated = now()
    
    return Dict(
        "success" => true,
        "paused" => session.paused,
        "message" => paused ? "Game paused" : "Game resumed"
    )
end

"""
    restart_game(game_id::String)::Dict

Restart a game session.
"""
function restart_game(game_id::String)::Dict
    if !haskey(SESSIONS, game_id)
        return Dict("success" => false, "error" => "Game not found")
    end
    
    session = SESSIONS[game_id]
    difficulty = session.difficulty
    
    # Create new session with same difficulty
    new_session = GameSession(difficulty)
    SESSIONS[game_id] = new_session
    
    return session_to_json(new_session)
end

"""
    set_speed(game_id::String, speed::String)::Dict

Set the game speed.
"""
function set_speed(game_id::String, speed::String)::Dict
    if !haskey(SESSIONS, game_id)
        return Dict("success" => false, "error" => "Game not found")
    end
    
    valid_speeds = ["slow", "normal", "fast"]
    if !(speed in valid_speeds)
        return Dict("success" => false, "error" => "Invalid speed: $speed")
    end
    
    session = SESSIONS[game_id]
    session.speed = speed
    session.last_updated = now()
    
    return Dict(
        "success" => true,
        "speed" => session.speed,
        "message" => "Speed set to $speed"
    )
end

"""
    handle_request(req::HTTP.Request)::HTTP.Response

Main request handler for the API.
"""
function handle_request(req::HTTP.Request)::HTTP.Response
    # Enable CORS
    if req.method == "OPTIONS"
        return HTTP.Response(200, 
            ["Access-Control-Allow-Origin" => "*",
             "Access-Control-Allow-Methods" => "GET, POST, OPTIONS",
             "Access-Control-Allow-Headers" => "Content-Type"],
            "")
    end
    
    # Parse request
    path = HTTP.URI(req.target).path
    method = req.method
    
    try
        # Route requests
        if method == "POST" && path == "/api/game/new"
            body = JSON.parse(String(req.body))
            difficulty = get(body, "difficulty", "normal")
            result = create_game(difficulty)
            return json_response(result)
            
        elseif method == "GET" && startswith(path, "/api/game/") && endswith(path, "/state")
            game_id = split(path, "/")[4]
            result = get_game_state(game_id)
            return json_response(result)
            
        elseif method == "POST" && startswith(path, "/api/game/") && endswith(path, "/step")
            game_id = split(path, "/")[4]
            result = step_game(game_id)
            return json_response(result)
            
        elseif method == "POST" && startswith(path, "/api/game/") && endswith(path, "/place-pattern")
            game_id = split(path, "/")[4]
            body = JSON.parse(String(req.body))
            pattern = body["pattern"]
            row = body["row"]
            col = body["col"]
            result = place_pattern(game_id, pattern, row, col)
            return json_response(result)
            
        elseif method == "POST" && startswith(path, "/api/game/") && endswith(path, "/pause")
            game_id = split(path, "/")[4]
            body = JSON.parse(String(req.body))
            paused = body["paused"]
            result = pause_game(game_id, paused)
            return json_response(result)
            
        elseif method == "POST" && startswith(path, "/api/game/") && endswith(path, "/restart")
            game_id = split(path, "/")[4]
            result = restart_game(game_id)
            return json_response(result)
            
        elseif method == "POST" && startswith(path, "/api/game/") && endswith(path, "/set-speed")
            game_id = split(path, "/")[4]
            body = JSON.parse(String(req.body))
            speed = body["speed"]
            result = set_speed(game_id, speed)
            return json_response(result)
            
        else
            return HTTP.Response(404, [
                "Content-Type" => "application/json",
                "Access-Control-Allow-Origin" => "*"
            ], JSON.json(Dict("error" => "Endpoint not found")))
        end
        
    catch e
        return HTTP.Response(500, [
            "Content-Type" => "application/json",
            "Access-Control-Allow-Origin" => "*"
        ], JSON.json(Dict("error" => string(e))))
    end
end

"""
    json_response(data::Dict)::HTTP.Response

Create a JSON response.
"""
function json_response(data::Dict)::HTTP.Response
    return HTTP.Response(200,
        ["Content-Type" => "application/json",
         "Access-Control-Allow-Origin" => "*"],
        JSON.json(data))
end

"""
    start_server(port::Int=8000)

Start the API server.
"""
function start_server(port::Int=8000)
    println("Starting Game of Life API server on port $port...")
    HTTP.serve(handle_request, "127.0.0.1", port)
end
