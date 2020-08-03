function degrees(mg::AbstractMetaGraph, T::DataType=eltype(mg); dir::Symbol=:out)
    adj = adjacency_matrix(mg.graph, T; dir=dir)
    degrees(adj, T; dir=dir)
end

function degree_matrix(mg::AbstractMetaGraph, T::DataType=eltype(mg); dir::Symbol=:out)
    adj = adjacency_matrix(mg.graph, T; dir=dir)
    degree_matrix(adj, T; dir=dir)
end

function inv_sqrt_degree_matrix(mg::AbstractMetaGraph, T::DataType=eltype(mg); dir::Symbol=:out)
    adj = adjacency_matrix(mg.graph, T; dir=dir)
    inv_sqrt_degree_matrix(adj, T; dir=dir)
end

function laplacian_matrix(mg::AbstractMetaGraph, T::DataType=eltype(mg); dir::Symbol=:out)
    adj = adjacency_matrix(mg.graph, T; dir=dir)
    laplacian_matrix(adj, T; dir=dir)
end

function normalized_laplacian(mg::AbstractMetaGraph, T::DataType=eltype(mg); selfloop::Bool=false)
    adj = adjacency_matrix(mg.graph, T)
    selfloop && (adj += I)
    normalized_laplacian(adj, T)
end
