using PotatoModel
using Documenter

makedocs(
    sitename = "PotatoModel.jl",
    modules  = [PotatoModel],
    pages = ["Home" => "index.md"]
    )
    format = Documenter.HTML(;
    prettyurls = get(ENV, "CI", "false") == "true",
    )

deploydocs(;
    repo = "github.com/junhyukjeon/PotatoModel.jl",
    devbranch = "master"
)