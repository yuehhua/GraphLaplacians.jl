function add_self_loop!(adj::AbstractVector{T}, n::Int=length(adj)) where {T<:AbstractVector}
    for i = 1:n
        i in adj[i] || push!(adj[i], i)
    end
    adj
end
