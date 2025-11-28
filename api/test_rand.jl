using Pkg
Pkg.activate(".")
using Random
println("Random loaded successfully")
grid = rand(Bool, 200, 200)
println("Grid created with $(sum(grid)) live cells")
