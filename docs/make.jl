using GraphLaplacians
using Documenter

makedocs(;
    modules=[GraphLaplacians],
    authors="Yueh-Hua Tu",
    repo="https://github.com/yuehhua/GraphLaplacians.jl/blob/{commit}{path}#L{line}",
    sitename="GraphLaplacians.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://yuehhua.github.io/GraphLaplacians.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/yuehhua/GraphLaplacians.jl",
)
