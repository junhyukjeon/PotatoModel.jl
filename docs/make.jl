using PotatoModel
using Documenter

makedocs(
         sitename = "PotatoModel.jl",
         modules  = [PotatoModel],
         pages=[
                "Home" => "index.md"
               ])
               
deploydocs(;
    repo="github.com/junhyukjeon/PotatoModel.jl",
)