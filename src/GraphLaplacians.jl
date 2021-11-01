module GraphLaplacians

using ChainRulesCore: @non_differentiable
using SparseArrays: SparseMatrixCSC
using LinearAlgebra
using Graphs

include("adjmat.jl")
include("graphs.jl")

@non_differentiable adjacency_matrix(x...)
@non_differentiable degrees(x...)
@non_differentiable normalized_laplacian(x...)

end
