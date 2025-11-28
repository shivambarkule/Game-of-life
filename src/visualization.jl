"""
    Visualization Module

Provides visualization capabilities for Game of Life simulations using Plots.jl.
"""

using Plots

"""
    visualize(grid::Grid; generation::Int=0)

Create a static visualization of the grid.

Displays the grid as a heatmap with alive cells in white and dead cells in black.
The generation number is shown in the title.

# Arguments
- `grid::Grid`: The grid to visualize
- `generation::Int`: Generation number to display (default: 0)

# Returns
- Plot object that can be displayed or saved

# Examples
```julia
grid = Grid(50, 50)
place_pattern!(grid, get_pattern(:glider), 10, 10)
visualize(grid, generation=0)
```
"""
function visualize(grid::Grid; generation::Int=0)
    # Convert boolean grid to numeric for plotting (true=1, false=0)
    plot_data = Float64.(grid.cells)
    
    # Create heatmap with binary colormap
    p = heatmap(
        plot_data,
        color=:grays,
        aspect_ratio=:equal,
        title="Game of Life - Generation $generation",
        xlabel="",
        ylabel="",
        xticks=false,
        yticks=false,
        legend=false,
        framestyle=:box,
        size=(600, 600),
        clims=(0, 1)
    )
    
    return p
end

"""
    create_animation(sim::Simulation, generations::Int, fps::Int=10; filename::String="gameoflife.gif")

Create an animated GIF of the simulation.

# Arguments
- `sim::Simulation`: The simulation to animate
- `generations::Int`: Number of generations to include in animation
- `fps::Int`: Frames per second (default: 10)
- `filename::String`: Output filename (default: "gameoflife.gif")

# Examples
```julia
grid = Grid(50, 50)
place_pattern!(grid, get_pattern(:glider), 10, 10)
sim = Simulation(grid)
create_animation(sim, 50, 10, filename="glider.gif")
```
"""
function create_animation(sim::Simulation, generations::Int, fps::Int=10; filename::String="gameoflife.gif")
    # Reset simulation to start
    reset!(sim)
    
    # Create animation
    anim = @animate for i in 0:generations
        visualize(sim.current_grid, generation=sim.generation)
        if i < generations
            step!(sim)
        end
    end
    
    # Save as GIF
    gif(anim, filename, fps=fps)
    
    println("Animation saved to $filename")
    return filename
end

"""
    interactive_mode(sim::Simulation; fps::Int=10, max_generations::Int=1000)

Launch an interactive visualization that updates in real-time.

Note: This function runs the simulation continuously and displays updates.
For true interactivity with keyboard controls, use run_interactive from the interactive module.

# Arguments
- `sim::Simulation`: The simulation to visualize
- `fps::Int`: Target frames per second (default: 10)
- `max_generations::Int`: Maximum generations to run (default: 1000)

# Examples
```julia
grid = Grid(50, 50)
randomize!(grid, 0.3)
sim = Simulation(grid)
interactive_mode(sim, fps=15)
```
"""
function interactive_mode(sim::Simulation; fps::Int=10, max_generations::Int=1000)
    delay = 1.0 / fps
    
    println("Running simulation for $max_generations generations at $fps FPS")
    println("Close the plot window to stop.")
    
    # Create initial plot
    p = visualize(sim.current_grid, generation=sim.generation)
    display(p)
    
    # Run simulation with visualization updates
    for i in 1:max_generations
        step!(sim)
        
        # Update plot
        p = visualize(sim.current_grid, generation=sim.generation)
        display(p)
        
        # Frame rate limiting
        sleep(delay)
    end
    
    println("Simulation complete. Final generation: $(sim.generation)")
    return nothing
end
