module GraphLaplacians

using SparseArrays: SparseMatrixCSC
using LinearAlgebra: I, issymmetric, diagm, Diagonal, eigen, Symmetric
using LightGraphs
using MetaGraphs: AbstractMetaGraph
using Zygote

export
    # linalg
    degrees,
    degree_matrix,
    laplacian_matrix,
    normalized_laplacian,
    scaled_laplacian

include("linalg.jl")
include("graph.jl")
include("metagraphs.jl")
include("grad.jl")

end
