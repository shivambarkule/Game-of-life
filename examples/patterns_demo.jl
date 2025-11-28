# Patterns Demo for Game of Life
# This script showcases all predefined patterns available in the GameOfLife module

using Pkg
Pkg.activate(".")

using GameOfLife

println("=" ^ 60)
println("Game of Life - Patterns Showcase")
println("=" ^ 60)

# List of all available patterns
patterns = [:glider, :blinker, :toad, :beacon, :pulsar, :glider_gun]

println("\nAvailable patterns:")
for pattern_name in patterns
    println("  - $pattern_name")
end

# Create a large grid to showcase all patterns
grid = Grid(100, 100)

# Pattern 1: Glider (spaceship)
println("\n1. Glider - A small spaceship that moves diagonally")
println("   Period: 4, moves 1 cell diagonally every 4 generations")
place_pattern!(grid, get_pattern(:glider), 10, 10)

# Pattern 2: Blinker (oscillator)
println("\n2. Blinker - The smallest oscillator")
println("   Period: 2, alternates between horizontal and vertical")
place_pattern!(grid, get_pattern(:blinker), 20, 10)

# Pattern 3: Toad (oscillator)
println("\n3. Toad - A period-2 oscillator")
println("   Period: 2")
place_pattern!(grid, get_pattern(:toad), 30, 10)

# Pattern 4: Beacon (oscillator)
println("\n4. Beacon - A period-2 oscillator formed by two blocks")
println("   Period: 2")
place_pattern!(grid, get_pattern(:beacon), 40, 10)

# Pattern 5: Pulsar (oscillator)
println("\n5. Pulsar - A large period-3 oscillator with beautiful symmetry")
println("   Period: 3")
place_pattern!(grid, get_pattern(:pulsar), 50, 10)

# Pattern 6: Glider Gun (generator)
println("\n6. Gosper Glider Gun - Generates gliders indefinitely")
println("   Period: 30, produces a new glider every 30 generations")
place_pattern!(grid, get_pattern(:glider_gun), 10, 40)

# Visualize the initial state
println("\nVisualizing all patterns on a single grid...")
p = visualize(grid, generation=0)
display(p)

# Create a simulation and run it
println("\nCreating simulation...")
sim = Simulation(grid)

# Run for a few generations to see patterns evolve
println("Running simulation for 10 generations...")
for i in 1:10
    step!(sim)
    if i % 5 == 0
        println("  Generation $i")
        p = visualize(sim.current_grid, generation=sim.generation)
        display(p)
        sleep(0.5)  # Pause to see the visualization
    end
end

println("\n" ^ 60)
println("Pattern showcase complete!")
println("\nTry these patterns individually:")
println("  grid = Grid(50, 50)")
println("  place_pattern!(grid, get_pattern(:glider), 20, 20)")
println("  sim = Simulation(grid)")
println("  run_interactive(sim, fps=10, auto_start=true)")
println("=" ^ 60)

# Individual pattern demonstrations
println("\n\nIndividual Pattern Demonstrations")
println("=" ^ 60)

# Demo each pattern separately
for pattern_name in patterns
    println("\nDemonstrating: $pattern_name")
    
    # Create a clean grid for each pattern
    demo_grid = Grid(50, 50)
    pattern = get_pattern(pattern_name)
    
    # Place pattern in the center
    center_row = 25 - size(pattern, 1) ÷ 2
    center_col = 25 - size(pattern, 2) ÷ 2
    place_pattern!(demo_grid, pattern, center_row, center_col)
    
    # Create simulation
    demo_sim = Simulation(demo_grid)
    
    # Show initial state
    println("  Initial state:")
    p = visualize(demo_sim.current_grid, generation=0)
    display(p)
    
    # Run for a few generations
    println("  Running for 5 generations...")
    run!(demo_sim, 5)
    
    # Show final state
    p = visualize(demo_sim.current_grid, generation=demo_sim.generation)
    display(p)
    
    sleep(1)  # Pause between patterns
end

println("\n" ^ 60)
println("All pattern demonstrations complete!")
println("=" ^ 60)
