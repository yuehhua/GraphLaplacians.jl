using GraphLaplacians
using LinearAlgebra: I, diagm
using LightGraphs: SimpleGraph, SimpleDiGraph, add_edge!
using SimpleWeightedGraphs: SimpleWeightedGraph, SimpleWeightedDiGraph, add_edge!
using MetaGraphs: MetaGraph, MetaDiGraph
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
