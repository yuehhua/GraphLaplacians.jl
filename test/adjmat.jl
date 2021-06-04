@testset "adjmat" begin
    @testset "undirected" begin
        adj = [0 1 0 1;
               1 0 1 0;
               0 1 0 1;
               1 0 1 0]
        deg = [2 0 0 0;
               0 2 0 0;
               0 0 2 0;
               0 0 0 2]
        lap = [2 -1 0 -1;
               -1 2 -1 0;
               0 -1 2 -1;
               -1 0 -1 2]
        norm_lap = [1. -.5 0. -.5;
                   -.5 1. -.5 0.;
                   0. -.5 1. -.5;
                   -.5 0. -.5 1.]
        scaled_lap = [0 -0.5 0 -0.5;
                      -0.5 0 -0.5 -0;
                      0 -0.5 0 -0.5;
                      -0.5 0 -0.5 0]
        rw_lap = [1 -0.5 0 -0.5;
                  -0.5 1 -0.5 -0;
                  0 -0.5 1 -0.5;
                  -0.5 0 -0.5 1]

        for T in [Int8, Int16, Int32, Int64, Float16, Float32, Float64]
            D = degree_matrix(adj, T, dir=:out)
            @test D == T.(deg)
            @test D == degree_matrix(adj, T, dir=:in)
            @test D == degree_matrix(adj, T, dir=:both)
            @test eltype(D) == T

            L = laplacian_matrix(adj, T)
            @test L == T.(lap)
            @test eltype(L) == T

            SL = signless_laplacian(adj, T)
            @test SL == T.(adj + deg)
            @test eltype(SL) == T
        end
        for T in [Float16, Float32, Float64]
            NL = normalized_laplacian(adj, T)
            @test NL ≈ T.(norm_lap)
            @test eltype(NL) == T

            SL = scaled_laplacian(adj, T)
            @test SL ≈ T.(scaled_lap)
            @test eltype(SL) == T
            
            RW = random_walk_laplacian(adj, T)
            @test RW == T.(rw_lap)
            @test eltype(RW) == T
        end
    end

    @testset "directed" begin
        adj = [0 2 0 3;
               0 0 4 0;
               2 0 0 1;
               0 0 0 0]
        deg_out = [2 0 0 0;
                   0 2 0 0;
                   0 0 4 0;
                   0 0 0 4]
        deg_in = [5 0 0 0;
                  0 4 0 0;
                  0 0 3 0;
                  0 0 0 0]
        deg_both = [7 0 0 0;
                    0 6 0 0;
                    0 0 7 0;
                    0 0 0 4]

        for T in [Int8, Int16, Int32, Int64, Float16, Float32, Float64]
            D_out = degree_matrix(adj, T, dir=:out)
            D_in = degree_matrix(adj, T, dir=:in)
            D_both = degree_matrix(adj, T, dir=:both)
            @test D_out == T.(deg_out)
            @test D_in == T.(deg_in)
            @test D_both == T.(deg_both)
            @test eltype(D_out) == T
            @test eltype(D_in) == T
            @test eltype(D_both) == T
            @test_throws DomainError degree_matrix(adj, dir=:other)

            L_out = laplacian_matrix(adj, T, dir=:out)
            L_in = laplacian_matrix(adj, T, dir=:in)
            L_both = laplacian_matrix(adj, T, dir=:both)
            @test L_out == T.(deg_out .- adj)
            @test L_in == T.(deg_in .- adj)
            @test L_both == T.(deg_both .- adj)
            @test eltype(L_out) == T
            @test eltype(L_in) == T
            @test eltype(L_both) == T
        end
    end
end
