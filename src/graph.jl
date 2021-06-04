function degrees(g::AbstractGraph, T::DataType=eltype(g); dir::Symbol=:out)
    adj = LightGraphs.adjacency_matrix(g, T; dir=dir)
    degrees(adj, T; dir=dir)
end

function degree_matrix(g::AbstractGraph, T::DataType=eltype(g); dir::Symbol=:out)
    adj = LightGraphs.adjacency_matrix(g, T; dir=dir)
    degree_matrix(adj, T; dir=dir)
end

function inv_sqrt_degree_matrix(g::AbstractGraph, T::DataType=eltype(g); dir::Symbol=:out)
    adj = LightGraphs.adjacency_matrix(g, T; dir=dir)
    inv_sqrt_degree_matrix(adj, T; dir=dir)
end

function laplacian_matrix(g::AbstractGraph, T::DataType=eltype(g); dir::Symbol=:out)
    adj = LightGraphs.adjacency_matrix(g, T; dir=dir)
    laplacian_matrix(adj, T; dir=dir)
end

function normalized_laplacian(g::AbstractGraph, T::DataType=eltype(g); selfloop::Bool=false)
    adj = LightGraphs.adjacency_matrix(g, T)
    normalized_laplacian(adj, T, selfloop=selfloop)
end

function scaled_laplacian(g::AbstractGraph, T::DataType=eltype(g))
    adj = adjacency_matrix(g, T)
    scaled_laplacian(adj, T)
end


## MetaGraphs

degrees(mg::AbstractMetaGraph, T::DataType=eltype(mg); dir::Symbol=:out) = degrees(mg.graph, T; dir=dir)

degree_matrix(mg::AbstractMetaGraph, T::DataType=eltype(mg); dir::Symbol=:out) = degree_matrix(mg.graph, T; dir=dir)

inv_sqrt_degree_matrix(mg::AbstractMetaGraph, T::DataType=eltype(mg); dir::Symbol=:out) =
    inv_sqrt_degree_matrix(mg.graph, T; dir=dir)

laplacian_matrix(mg::AbstractMetaGraph, T::DataType=eltype(mg); dir::Symbol=:out) =
    laplacian_matrix(mg.graph, T; dir=dir)

normalized_laplacian(mg::AbstractMetaGraph, T::DataType=eltype(mg); selfloop::Bool=false) =
    normalized_laplacian(mg.graph, T, selfloop=selfloop)
