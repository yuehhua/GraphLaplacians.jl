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

sg = SimpleGraph(6)
add_edge!(sg, 1, 2); add_edge!(sg, 1, 3); add_edge!(sg, 2, 3)
add_edge!(sg, 3, 4); add_edge!(sg, 2, 5); add_edge!(sg, 3, 6)

ug = MetaGraph(sg)
dg = MetaDiGraph(sg)


@testset "metagraphs" begin
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
