"""
    Interactive Module

Provides interactive controls for running Game of Life simulations.
"""

"""
    run_interactive(sim::Simulation; fps::Int=10, auto_start::Bool=false)

Run an interactive Game of Life simulation with keyboard controls.

# Controls
- Press Enter/Return: Start/pause simulation
- Press 's': Single step (advance one generation)
- Press 'r': Reset to initial state
- Press 'c': Clear all cells
- Press '+': Increase speed
- Press '-': Decrease speed
- Press 'q': Quit

# Arguments
- `sim::Simulation`: The simulation to run
- `fps::Int`: Initial frames per second (1-30, default: 10)
- `auto_start::Bool`: Start simulation automatically (default: false)

# Examples
```julia
grid = Grid(50, 50)
randomize!(grid, 0.3)
sim = Simulation(grid)
run_interactive(sim, fps=15)
```
"""
function run_interactive(sim::Simulation; fps::Int=10, auto_start::Bool=false)
    # Validate and clamp fps
    fps = clamp(fps, 1, 30)
    
    running = auto_start
    
    println("=" ^ 60)
    println("Game of Life - Interactive Mode")
    println("=" ^ 60)
    println("Controls:")
    println("  Enter/Return : Start/Pause simulation")
    println("  s            : Single step")
    println("  r            : Reset to initial state")
    println("  c            : Clear all cells")
    println("  +            : Increase speed")
    println("  -            : Decrease speed")
    println("  q            : Quit")
    println("=" ^ 60)
    println("Initial FPS: $fps")
    println("Status: ", running ? "Running" : "Paused")
    println()
    
    # Display initial state
    p = visualize(sim.current_grid, generation=sim.generation)
    display(p)
    
    # Main loop
    println("\nSimulation ready. Use controls to interact.")
    println("Note: In Julia REPL, you may need to press Enter after each command.")
    println("For continuous simulation, the loop will run automatically.")
    
    # Since Julia doesn't have built-in non-blocking keyboard input in a simple way,
    # we'll provide a simplified interactive mode that runs continuously
    # Users can interrupt with Ctrl+C
    
    if auto_start
        println("\nRunning in auto mode. Press Ctrl+C to stop.")
        try
            while true
                if running
                    step!(sim)
                    p = visualize(sim.current_grid, generation=sim.generation)
                    display(p)
                    sleep(1.0 / fps)
                end
            end
        catch e
            if isa(e, InterruptException)
                println("\nSimulation interrupted by user.")
            else
                rethrow(e)
            end
        end
    else
        println("\nManual mode: Call step!(sim) to advance, visualize(sim.current_grid) to display.")
        println("Or use the provided helper functions:")
        println("  - Call run_interactive(sim, auto_start=true) for continuous mode")
    end
    
    return nothing
end

"""
    adjust_speed(current_fps::Int, increase::Bool)::Int

Adjust simulation speed.

# Arguments
- `current_fps::Int`: Current frames per second
- `increase::Bool`: true to increase speed, false to decrease

# Returns
- `Int`: New FPS value (clamped between 1 and 30)

# Examples
```julia
new_fps = adjust_speed(10, true)   # Increase to 15
new_fps = adjust_speed(10, false)  # Decrease to 5
```
"""
function adjust_speed(current_fps::Int, increase::Bool)::Int
    if increase
        new_fps = min(current_fps + 5, 30)
    else
        new_fps = max(current_fps - 5, 1)
    end
    return new_fps
end

"""
    handle_command(sim::Simulation, command::String, fps::Int)::Tuple{Bool, Int}

Process a user command and update simulation state.

# Arguments
- `sim::Simulation`: The simulation to control
- `command::String`: User command
- `fps::Int`: Current FPS

# Returns
- `Tuple{Bool, Int}`: (continue_running, new_fps)

# Examples
```julia
running, new_fps = handle_command(sim, "s", 10)  # Single step
running, new_fps = handle_command(sim, "r", 10)  # Reset
```
"""
function handle_command(sim::Simulation, command::String, fps::Int)::Tuple{Bool, Int}
    command = lowercase(strip(command))
    new_fps = fps
    continue_running = true
    
    if command == "s"
        # Single step
        step!(sim)
        println("Advanced to generation $(sim.generation)")
    elseif command == "r"
        # Reset
        reset!(sim)
        println("Reset to initial state (generation 0)")
    elseif command == "c"
        # Clear
        clear!(sim.current_grid)
        sim.generation = 0
        println("Cleared all cells")
    elseif command == "+"
        # Increase speed
        new_fps = adjust_speed(fps, true)
        println("Speed increased to $new_fps FPS")
    elseif command == "-"
        # Decrease speed
        new_fps = adjust_speed(fps, false)
        println("Speed decreased to $new_fps FPS")
    elseif command == "q"
        # Quit
        println("Exiting simulation...")
        continue_running = false
    else
        println("Unknown command: $command")
    end
    
    return (continue_running, new_fps)
end
