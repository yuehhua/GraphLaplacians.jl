in_channel = 3
out_channel = 5
N = 6
adj = [0. 1. 1. 0. 0. 0.;
       1. 0. 1. 0. 1. 0.;
       1. 1. 0. 1. 0. 1.;
       0. 0. 1. 0. 0. 0.;
       0. 1. 0. 0. 0. 0.;
       0. 0. 1. 0. 0. 0.]
deg = [2. 0. 0. 0. 0. 0.;
       0. 3. 0. 0. 0. 0.;
       0. 0. 4. 0. 0. 0.;
       0. 0. 0. 1. 0. 0.;
       0. 0. 0. 0. 1. 0.;
       0. 0. 0. 0. 0. 1.]
lap = [2. -1. -1. 0. 0. 0.;
       -1. 3. -1. 0. -1. 0.;
       -1. -1. 4. -1. 0. -1.;
       0. 0. -1. 1. 0. 0.;
       0. -1. 0. 0. 1. 0.;
       0. 0. -1. 0. 0. 1.]
norm_lap = [1. -1/sqrt(2*3) -1/sqrt(2*4) 0. 0. 0.;
            -1/sqrt(2*3) 1. -1/sqrt(3*4) 0. -1/sqrt(3) 0.;
            -1/sqrt(2*4) -1/sqrt(3*4) 1. -1/2 0. -1/2;
            0. 0. -1/2 1. 0. 0.;
            0. -1/sqrt(3) 0. 0. 1. 0.;
            0. 0. -1/2 0. 0. 1.]

ug = SimpleGraph(6)
add_edge!(ug, 1, 2); add_edge!(ug, 1, 3); add_edge!(ug, 2, 3)
add_edge!(ug, 3, 4); add_edge!(ug, 2, 5); add_edge!(ug, 3, 6)

dg = SimpleDiGraph(6)
add_edge!(dg, 1, 3); add_edge!(dg, 2, 3); add_edge!(dg, 1, 6)
add_edge!(dg, 2, 5); add_edge!(dg, 3, 4); add_edge!(dg, 3, 5)

el_ug = Vector{Int64}[[2, 3], [1, 3, 5], [1, 2, 4, 6], [3], [2], [3]]
el_dg = Vector{Int64}[[3, 6], [3, 5], [4, 5], [], [], []]

@testset "simplegraphs" begin
    for T in [Int8, Int16, Int32, Int64, Int128]
        @test degree_matrix(adj, T, dir=:out) == T.(deg)
        @test degree_matrix(adj, T, dir=:out) == degree_matrix(adj, T, dir=:in)
        @test degree_matrix(adj, T, dir=:out) == degree_matrix(adj, T, dir=:both)
        @test laplacian_matrix(adj, T) == T.(lap)
    end
    for T in [Float16, Float32, Float64]
        @test degree_matrix(adj, T, dir=:out) == T.(deg)
        @test degree_matrix(adj, T, dir=:out) == degree_matrix(adj, T, dir=:in)
        @test degree_matrix(adj, T, dir=:out) == degree_matrix(adj, T, dir=:both)
        @test laplacian_matrix(adj, T) == T.(lap)
        @test normalized_laplacian(adj, T) ≈ T.(norm_lap)
    end
end
