Zygote.@nograd issymmetric

Zygote.@nograd function adjacency_matrix(adj::AbstractMatrix, T::DataType=eltype(adj))
    m, n = size(adj)
    (m == n) || throw(DimensionMismatch("adjacency matrix is not a square matrix: ($m, $n)"))
    T.(adj)
end

"""
    degrees(g[, T]; dir=:out)

Degree of each vertex. Return a vector which contains the degree of each vertex in graph `g`.

# Arguments

- `g`: should be a adjacency matrix, `SimpleGraph`, `SimpleDiGraph` (from LightGraphs) or `SimpleWeightedGraph`, `SimpleWeightedDiGraph` (from SimpleWeightedGraphs).
- `T`: result element type of degree vector; default is the element type of `g` (optional).
- `dir`: direction of degree; should be `:in`, `:out`, or `:both` (optional).

# Examples

```jldoctest
julia> using GraphLaplacians

julia> m = [0 1 1; 1 0 0; 1 0 0];

julia> GraphLaplacians.degrees(m)
3-element Vector{Int64}:
 2
 1
 1
```
"""
function degrees(adj::AbstractMatrix; dir::Symbol=:out)
    if issymmetric(adj)
        d = vec(sum(adj, dims=1))
    else
        if dir == :out
            d = vec(sum(adj, dims=1))
        elseif dir == :in
            d = vec(sum(adj, dims=2))
        elseif dir == :both
            d = vec(sum(adj, dims=1)) + vec(sum(adj, dims=2))
        else
            throw(DomainError(dir, "invalid argument, only accept :in, :out and :both"))
        end
    end
    d
end

degrees(adj::AbstractMatrix, T::DataType; dir::Symbol=:out) = degrees(T.(adj); dir=dir)

Zygote.@nograd degrees

"""
    degree_matrix(g[, T]; dir=:out)

Degree matrix of graph `g`. Return a matrix which contains degrees of each vertex in its diagonal.
The values other than diagonal are zeros.

# Arguments

- `g`: should be a adjacency matrix, `FeaturedGraph`, `SimpleGraph`, `SimpleDiGraph` (from LightGraphs) or `SimpleWeightedGraph`, `SimpleWeightedDiGraph` (from SimpleWeightedGraphs).
- `T`: result element type of degree vector; default is the element type of `g` (optional).
- `dir`: direction of degree; should be `:in`, `:out`, or `:both` (optional).

# Examples

```jldoctest
julia> using GraphLaplacians

julia> m = [0 1 1; 1 0 0; 1 0 0];

julia> GraphLaplacians.degree_matrix(m)
3×3 Diagonal{Int64, Vector{Int64}}:
 2  ⋅  ⋅
 ⋅  1  ⋅
 ⋅  ⋅  1
```
"""
function degree_matrix(adj::AbstractMatrix, T::DataType=eltype(adj); dir::Symbol=:out)
    d = degrees(adj, T, dir=dir)
    return Diagonal(T.(d))
end

"""
    inv_sqrt_degree_matrix(g[, T]; dir=:out)

Inverse squared degree matrix of graph `g`. Return a matrix which contains inverse squared degrees of each vertex in its diagonal.
The values other than diagonal are zeros.

# Arguments

- `g`: should be a adjacency matrix, `FeaturedGraph`, `SimpleGraph`, `SimpleDiGraph` (from LightGraphs) or `SimpleWeightedGraph`, `SimpleWeightedDiGraph` (from SimpleWeightedGraphs).
- `T`: result element type of degree vector; default is the element type of `g` (optional).
- `dir`: direction of degree; should be `:in`, `:out`, or `:both` (optional).
"""
function inv_sqrt_degree_matrix(adj::AbstractMatrix, T::DataType=eltype(adj); dir::Symbol=:out)
    d = inv.(sqrt.(degrees(adj, T, dir=dir)))
    return Diagonal(d)
end

"""
    laplacian_matrix(g[, T]; dir=:out)

Laplacian matrix of graph `g`.

# Arguments

- `g`: should be a adjacency matrix, `FeaturedGraph`, `SimpleGraph`, `SimpleDiGraph` (from LightGraphs) or `SimpleWeightedGraph`, `SimpleWeightedDiGraph` (from SimpleWeightedGraphs).
- `T`: result element type of degree vector; default is the element type of `g` (optional).
- `dir`: direction of degree; should be `:in`, `:out`, or `:both` (optional).
"""
function laplacian_matrix(adj::AbstractMatrix, T::DataType=eltype(adj); dir::Symbol=:out)
    degree_matrix(adj, T, dir=dir) - SparseMatrixCSC(T.(adj))
end

"""
    normalized_laplacian(g[, T]; selfloop=false)

Normalized Laplacian matrix of graph `g`.

# Arguments

- `g`: should be a adjacency matrix, `FeaturedGraph`, `SimpleGraph`, `SimpleDiGraph` (from LightGraphs) or `SimpleWeightedGraph`, `SimpleWeightedDiGraph` (from SimpleWeightedGraphs).
- `T`: result element type of degree vector; default is the element type of `g` (optional).
- `selfloop`: adding self loop while calculating the matrix (optional).
"""
function normalized_laplacian(adj::AbstractMatrix, T::DataType=eltype(adj); selfloop::Bool=false)
    selfloop && (adj += I)
    inv_sqrtD = inv_sqrt_degree_matrix(adj, T, dir=:both)
    T.(I - inv_sqrtD * adj * inv_sqrtD)
end

Zygote.@nograd normalized_laplacian

@doc raw"""
    scaled_laplacian(g[, T])

Scaled Laplacien matrix of graph `g`,
defined as ``\hat{L} = \frac{2}{\lambda_{max}} L - I`` where ``L`` is the normalized Laplacian matrix.

# Arguments

- `g`: should be a adjacency matrix, `FeaturedGraph`, `SimpleGraph`, `SimpleDiGraph` (from LightGraphs) or `SimpleWeightedGraph`, `SimpleWeightedDiGraph` (from SimpleWeightedGraphs).
- `T`: result element type of degree vector; default is the element type of `g` (optional).
"""
function scaled_laplacian(adj::AbstractMatrix, T::DataType=eltype(adj))
    @assert issymmetric(adj) "scaled_laplacian only works with symmetric matrices"
    E = eigen(Symmetric(adj)).values
    T(2. / maximum(E)) * normalized_laplacian(adj, T) - I
end

function random_walk_laplacian(adj::AbstractMatrix, T::DataType=eltype(adj); dir::Symbol=:out)
    P = inv(degree_matrix(adj, T, dir=dir)) * adj
    SparseMatrixCSC(I - P)
end

function signless_laplacian(adj::AbstractMatrix, T::DataType=eltype(adj); dir::Symbol=:out)
    degree_matrix(adj, T, dir=dir) + SparseMatrixCSC(T.(adj))
end