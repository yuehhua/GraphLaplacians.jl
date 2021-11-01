"""
    degrees(g[, T]; dir=:out)

Degree of each vertex. Return a vector which contains the degree of each vertex in graph `g`.

# Arguments

- `g`: should be a adjacency matrix, `SimpleGraph`, `SimpleDiGraph` (from Graphs) or `SimpleWeightedGraph`, `SimpleWeightedDiGraph` (from SimpleWeightedGraphs).
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
function degrees(g::AbstractGraph, T::DataType=eltype(g); dir::Symbol=:out)
    adj = Graphs.adjacency_matrix(g, T; dir=dir)
    degrees(adj, T; dir=dir)
end

function degree_matrix(g::AbstractGraph, T::DataType=eltype(g); dir::Symbol=:out)
    adj = Graphs.adjacency_matrix(g, T; dir=dir)
    degree_matrix(adj, T; dir=dir)
end

# Graphs.laplacian_matrix(g::AbstractGraph, T::DataType=eltype(g); dir::Symbol=:out)

function normalized_laplacian(g::AbstractGraph, T::DataType=eltype(g);
                              dir::Symbol=:both, selfloop::Bool=false)
    adj = Graphs.adjacency_matrix(g, T)
    normalized_laplacian(adj, T, dir=dir, selfloop=selfloop)
end

function scaled_laplacian(g::AbstractGraph, T::DataType=eltype(g))
    adj = adjacency_matrix(g, T)
    scaled_laplacian(adj, T)
end
