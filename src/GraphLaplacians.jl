module GraphLaplacians

using ChainRulesCore: @non_differentiable
using SparseArrays: SparseMatrixCSC
using LinearAlgebra: I, issymmetric, diagm, Diagonal, eigen, Symmetric
using LightGraphs
using MetaGraphs: AbstractMetaGraph

export
    # linalg
    degrees,
    degree_matrix,
    laplacian_matrix,
    normalized_laplacian,
    scaled_laplacian,
    random_walk_laplacian,
    signless_laplacian

include("adjmat.jl")
include("graphs.jl")

@non_differentiable adjacency_matrix(x...)
@non_differentiable degrees(x...)
@non_differentiable normalized_laplacian(x...)

end
