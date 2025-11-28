using Test
using GameOfLife

println("=" ^ 60)
println("Running GameOfLife Test Suite")
println("=" ^ 60)

# Run all test files
@testset "GameOfLife.jl" begin
    include("test_grid.jl")
    include("test_patterns.jl")
    include("test_simulation.jl")
    include("test_fileio.jl")
end

println("=" ^ 60)
println("All tests completed!")
println("=" ^ 60)
