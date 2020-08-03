using GraphLaplacians
using LightGraphs: SimpleGraph, SimpleDiGraph, add_edge!
using SimpleWeightedGraphs: SimpleWeightedGraph, SimpleWeightedDiGraph, add_edge!
using MetaGraphs: MetaGraph, MetaDiGraph
using Zygote
using Test

tests = [
    "linalg",
    "simplegraphs",
    "weightedgraphs",
    "metagraphs",
]

@testset "GraphLaplacians.jl" begin
    for t in tests
        include("$(t).jl")
    end
end
