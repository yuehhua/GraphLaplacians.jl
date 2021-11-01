using SparseArrays

@testset "sparse" begin
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
                      -0.5 0 -0.5 0;
                      0 -0.5 0 -0.5;
                      -0.5 0 -0.5 0]
        rw_lap = [1 -0.5 0 -0.5;
                  -0.5 1 -0.5 0;
                  0 -0.5 1 -0.5;
                  -0.5 0 -0.5 1]

        for T in [Int8, Int16, Int32, Int64, Int128, Float16, Float32, Float64]
            D = GraphLaplacians.degree_matrix(sparse(adj), T, dir=:out)
            @test D == T.(deg)
            @test D == GraphLaplacians.degree_matrix(sparse(adj), T, dir=:in)
            @test D == GraphLaplacians.degree_matrix(sparse(adj), T, dir=:both)
            @test eltype(D) == T

            L = Graphs.laplacian_matrix(sparse(adj), T)
            @test L == T.(lap)
            @test eltype(L) == T

            SL = GraphLaplacians.signless_laplacian(sparse(adj), T)
            @test SL == T.(adj + deg)
            @test eltype(SL) == T
        end

        for T in [Float16, Float32, Float64]
            NL = GraphLaplacians.normalized_laplacian(sparse(adj), T)
            @test NL ≈ T.(norm_lap)
            @test eltype(NL) == T

            SL = GraphLaplacians.scaled_laplacian(sparse(adj), T)
            @test SL ≈ T.(scaled_lap)
            @test eltype(SL) == T
            
            RW = GraphLaplacians.random_walk_laplacian(sparse(adj), T)
            @test RW == T.(rw_lap)
            @test eltype(RW) == T
        end
    end

    @testset "directed" begin
        adj = [0 2 0 3;
               0 0 4 0;
               2 0 0 1;
               0 0 0 0]
        degs = Dict(
            :out  => diagm(0=>[2, 2, 4, 4]),
            :in   => diagm(0=>[5, 4, 3, 0]),
            :both => diagm(0=>[7, 6, 7, 4]),
        )
        laps = Dict(
            :out  => degs[:out] - adj,
            :in   => degs[:in] - adj,
            :both => degs[:both] - adj,
        )
        sig_laps = Dict(
            :out  => degs[:out] + adj,
            :in   => degs[:in] + adj,
            :both => degs[:both] + adj,
        )
        rw_laps = Dict(
            :out  => I - diagm(0=>[1/2, 1/2, 1/4, 1/4]) * adj,
            :in   => I - diagm(0=>[1/5, 1/4, 1/3, 0]) * adj,
            :both => I - diagm(0=>[1/7, 1/6, 1/7, 1/4]) * adj,
        )

        for T in [Int8, Int16, Int32, Int64, Int128, Float16, Float32, Float64]
            for dir in [:out, :in, :both]
                D = GraphLaplacians.degree_matrix(sparse(adj), T, dir=dir)
                @test D == T.(degs[dir])
                @test eltype(D) == T
            end
            @test_throws DomainError GraphLaplacians.degree_matrix(adj, dir=:other)

            for dir in [:out, :in, :both]
                L = Graphs.laplacian_matrix(sparse(adj), T, dir=dir)
                @test L == T.(laps[dir])
                @test eltype(L) == T
            end

            for dir in [:out, :in, :both]
                SL = GraphLaplacians.signless_laplacian(sparse(adj), T, dir=dir)
                @test SL == T.(sig_laps[dir])
                @test eltype(SL) == T
            end
        end

        for T in [Float16, Float32, Float64]
            for dir in [:out, :in, :both]
                RW = GraphLaplacians.random_walk_laplacian(sparse(adj), T, dir=dir)
                @test RW == T.(rw_laps[dir])
                @test eltype(RW) == T
            end
        end
    end
end