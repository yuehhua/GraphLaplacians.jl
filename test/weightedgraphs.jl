in_channel = 3
out_channel = 5
N = 6
adj = [0. 2. 2. 0. 0. 0.;
       2. 0. 1. 0. 2. 0.;
       2. 1. 0. 5. 0. 2.;
       0. 0. 5. 0. 0. 0.;
       0. 2. 0. 0. 0. 0.;
       0. 0. 2. 0. 0. 0.]
deg = [4. 0. 0. 0. 0. 0.;
       0. 5. 0. 0. 0. 0.;
       0. 0. 10. 0. 0. 0.;
       0. 0. 0. 5. 0. 0.;
       0. 0. 0. 0. 2. 0.;
       0. 0. 0. 0. 0. 2.]
lap = [4. -2. -2. 0. 0. 0.;
       -2. 5. -1. 0. -2. 0.;
       -2. -1. 10. -5. 0. -2.;
       0. 0. -5. 5. 0. 0.;
       0. -2. 0. 0. 2. 0.;
       0. 0. -2. 0. 0. 2.]
norm_lap = [1. -2/sqrt(4*5) -2/sqrt(4*10) 0. 0. 0.;
            -2/sqrt(4*5) 1. -1/sqrt(5*10) 0. -2/sqrt(2*5) 0.;
            -2/sqrt(4*10) -1/sqrt(5*10) 1. -5/sqrt(5*10) 0. -2/sqrt(2*10);
            0. 0. -5/sqrt(5*10) 1. 0. 0.;
            0. -2/sqrt(2*5) 0. 0. 1. 0.;
            0. 0. -2/sqrt(2*10) 0. 0. 1.]

ug = SimpleWeightedGraph(6)
add_edge!(ug, 1, 2, 2); add_edge!(ug, 1, 3, 2); add_edge!(ug, 2, 3, 1)
add_edge!(ug, 3, 4, 5); add_edge!(ug, 2, 5, 2); add_edge!(ug, 3, 6, 2)

dg = SimpleWeightedDiGraph(6)
add_edge!(dg, 1, 3, 2); add_edge!(dg, 2, 3, 2); add_edge!(dg, 1, 6, 1)
add_edge!(dg, 2, 5, -2); add_edge!(dg, 3, 4, -2); add_edge!(dg, 3, 5, -1)

el_ug = Vector{Int64}[[2, 3], [1, 3, 5], [1, 2, 4, 6], [3], [2], [3]]
el_dg = Vector{Int64}[[3, 6], [3, 5], [4, 5], [], [], []]

@testset "weightedgraphs" begin
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
