module PotatoModel

using Cropbox

include("ASTRO.jl")
include("CROPP.jl")
include("LINTER.jl")
include("PENMAN.jl")
include("WATBALS.jl")
include("WEATHR.jl")
include("CONFIG.jl")

@system Model(ASTRO, CROPP, LINTER, PENMAN, WATBALS, WEATHR, CONFIG, Controller)

export Model

end
