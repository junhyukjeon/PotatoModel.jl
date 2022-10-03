using Cropbox
using CSV
using PotatoModel
using Test

@testset "PotatoModel.jl" begin
    include("PotatoModel.jl")
    include("ASTRO.jl")
    include("CONFIG.jl")
    include("CROPP.jl")
    include("PENMAN.jl")
    include("WATBALS.jl")
    include("WEATHR.jl")
end
