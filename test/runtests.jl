using GraphLaplacians
using LinearAlgebra
using Graphs
using SimpleWeightedGraphs
using Test

tests = [
    "adjmat",
    "sparse",
    "graphs",
]

@testset "GraphLaplacians.jl" begin
    for t in tests
        include("$(t).jl")
    end
end
