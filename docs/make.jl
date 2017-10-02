using Documenter, NarmaxLasso

makedocs(
    format = :html,
    sitename = "NarmaxLasso.jl",
    authors="Antonio H. Ribeiro",
    pages = Any[
        "Home" => "index.md",
        "Installation" => "installation.md",
        "Guide" => "guide.md",
        "Library" => "library.md"
    ]
)

deploydocs(
    repo = "https://github.com/antonior92/NarmaxLasso.jl.git",
    target = "build",
    julia = "0.6",
    osname = "linux",
    deps = nothing,
    make = nothing,
)
