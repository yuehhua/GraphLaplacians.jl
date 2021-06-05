in_channel = 3
out_channel = 5
N = 6

adjs = Dict(
    :simple => [0. 1. 1. 0. 0. 0.;
                1. 0. 1. 0. 1. 0.;
                1. 1. 0. 1. 0. 1.;
                0. 0. 1. 0. 0. 0.;
                0. 1. 0. 0. 0. 0.;
                0. 0. 1. 0. 0. 0.],
    :weight => [0. 2. 2. 0. 0. 0.;
                2. 0. 1. 0. 2. 0.;
                2. 1. 0. 5. 0. 2.;
                0. 0. 5. 0. 0. 0.;
                0. 2. 0. 0. 0. 0.;
                0. 0. 2. 0. 0. 0.],
)

degs = Dict(
    :simple => [2. 0. 0. 0. 0. 0.;
                0. 3. 0. 0. 0. 0.;
                0. 0. 4. 0. 0. 0.;
                0. 0. 0. 1. 0. 0.;
                0. 0. 0. 0. 1. 0.;
                0. 0. 0. 0. 0. 1.],
    :weight => [4. 0. 0. 0. 0. 0.;
                0. 5. 0. 0. 0. 0.;
                0. 0. 10. 0. 0. 0.;
                0. 0. 0. 5. 0. 0.;
                0. 0. 0. 0. 2. 0.;
                0. 0. 0. 0. 0. 2.]
)

laps = Dict(
    :simple => [2. -1. -1. 0. 0. 0.;
                -1. 3. -1. 0. -1. 0.;
                -1. -1. 4. -1. 0. -1.;
                0. 0. -1. 1. 0. 0.;
                0. -1. 0. 0. 1. 0.;
                0. 0. -1. 0. 0. 1.],
    :weight => [4. -2. -2. 0. 0. 0.;
                -2. 5. -1. 0. -2. 0.;
                -2. -1. 10. -5. 0. -2.;
                0. 0. -5. 5. 0. 0.;
                0. -2. 0. 0. 2. 0.;
                0. 0. -2. 0. 0. 2.],
)

norm_laps = Dict(
    :simple => [1. -1/sqrt(2*3) -1/sqrt(2*4) 0. 0. 0.;
                -1/sqrt(2*3) 1. -1/sqrt(3*4) 0. -1/sqrt(3) 0.;
                -1/sqrt(2*4) -1/sqrt(3*4) 1. -1/2 0. -1/2;
                0. 0. -1/2 1. 0. 0.;
                0. -1/sqrt(3) 0. 0. 1. 0.;
                0. 0. -1/2 0. 0. 1.],
    :weight => [1. -2/sqrt(4*5) -2/sqrt(4*10) 0. 0. 0.;
                -2/sqrt(4*5) 1. -1/sqrt(5*10) 0. -2/sqrt(2*5) 0.;
                -2/sqrt(4*10) -1/sqrt(5*10) 1. -5/sqrt(5*10) 0. -2/sqrt(2*10);
                0. 0. -5/sqrt(5*10) 1. 0. 0.;
                0. -2/sqrt(2*5) 0. 0. 1. 0.;
                0. 0. -2/sqrt(2*10) 0. 0. 1.]
)

ugs = Dict(
    :simple => SimpleGraph(N),
    :weight => SimpleWeightedGraph(N),
)

dgs = Dict(
    :simple => SimpleDiGraph(N),
    :weight => SimpleWeightedDiGraph(N),
)

add_edge!(ugs[:simple], 1, 2); add_edge!(ugs[:simple], 1, 3);
add_edge!(ugs[:simple], 2, 3); add_edge!(ugs[:simple], 3, 4)
add_edge!(ugs[:simple], 2, 5); add_edge!(ugs[:simple], 3, 6)

add_edge!(dgs[:simple], 1, 3); add_edge!(dgs[:simple], 2, 3)
add_edge!(dgs[:simple], 1, 6); add_edge!(dgs[:simple], 2, 5)
add_edge!(dgs[:simple], 3, 4); add_edge!(dgs[:simple], 3, 5)

add_edge!(ugs[:weight], 1, 2, 2); add_edge!(ugs[:weight], 1, 3, 2)
add_edge!(ugs[:weight], 2, 3, 1); add_edge!(ugs[:weight], 3, 4, 5)
add_edge!(ugs[:weight], 2, 5, 2); add_edge!(ugs[:weight], 3, 6, 2)

add_edge!(dgs[:weight], 1, 3, 2); add_edge!(dgs[:weight], 2, 3, 2)
add_edge!(dgs[:weight], 1, 6, 1); add_edge!(dgs[:weight], 2, 5, -2)
add_edge!(dgs[:weight], 3, 4, -2); add_edge!(dgs[:weight], 3, 5, -1)

ugs[:meta] = MetaGraph(ugs[:simple])
dgs[:meta] = MetaDiGraph(dgs[:simple])

@testset "graphs" begin
    @testset "simplegraphs" begin
        g = ugs[:simple]
        for T in [Int8, Int16, Int32, Int64, Int128, Float16, Float32, Float64]
            @test degree_matrix(g, T, dir=:out) == T.(degs[:simple])
            @test degree_matrix(g, T, dir=:out) == degree_matrix(adjs[:simple], T, dir=:in)
            @test degree_matrix(g, T, dir=:out) == degree_matrix(adjs[:simple], T, dir=:both)
            @test laplacian_matrix(g, T) == T.(laps[:simple])
        end
        for T in [Float16, Float32, Float64]
            @test normalized_laplacian(g, T) ≈ T.(norm_laps[:simple])
        end
    end

    @testset "weightedgraphs" begin
        g = ugs[:weight]
        for T in [Int8, Int16, Int32, Int64, Int128, Float16, Float32, Float64]
            @test degree_matrix(g, T, dir=:out) == T.(degs[:weight])
            @test degree_matrix(g, T, dir=:out) == degree_matrix(adjs[:weight], T, dir=:in)
            @test degree_matrix(g, T, dir=:out) == degree_matrix(adjs[:weight], T, dir=:both)
            @test laplacian_matrix(g, T) == T.(laps[:weight])
        end
        for T in [Float16, Float32, Float64]
            @test normalized_laplacian(g, T) ≈ T.(norm_laps[:weight])
        end
    end

    @testset "metagraphs" begin
        g = ugs[:meta]
        for T in [Int8, Int16, Int32, Int64, Int128, Float16, Float32, Float64]
            @test degree_matrix(g, T, dir=:out) == T.(degs[:simple])
            @test degree_matrix(g, T, dir=:out) == degree_matrix(adjs[:simple], T, dir=:in)
            @test degree_matrix(g, T, dir=:out) == degree_matrix(adjs[:simple], T, dir=:both)
            @test laplacian_matrix(g, T) == T.(laps[:simple])
        end
        for T in [Float16, Float32, Float64]
            @test normalized_laplacian(g, T) ≈ T.(norm_laps[:simple])
        end
    end
end
