Zygote.@nograd issymmetric

Zygote.@nograd function adjacency_matrix(adj::AbstractMatrix, T::DataType=eltype(adj))
    m, n = size(adj)
    (m == n) || throw(DimensionMismatch("adjacency matrix is not a square matrix: ($m, $n)"))
    T.(adj)
end

# nograd can only used without keyword arguments
Zygote.@nograd function _degrees(adj::AbstractMatrix, dir::Symbol=:out)
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

# nograd can only used without keyword arguments
Zygote.@nograd function _normalized_laplacian(adj::AbstractMatrix, T::DataType=eltype(adj))
    inv_sqrtD = inv_sqrt_degree_matrix(adj, T, dir=:both)
    T.(I - inv_sqrtD * adj * inv_sqrtD)
end
