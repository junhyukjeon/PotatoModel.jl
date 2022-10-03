using Cropbox
using PotatoModel
using Test

using PotatoModel: ASTRO, CROPP, LINTER, PENMAN, WATBALS, WEATHR, CONFIG

@system CROPPController(ASTRO, CROPP, LINTER, PENMAN, WATBALS, WEATHR, CONFIG, Controller)

@testset "CROPP" begin
    config = @config(
        :Calendar => :init => ZonedDateTime(1971, 4, 15, tz"UTC"),
        :Clock => :step => 1u"d",
        :WEATHR => :W => CSV.File(joinpath(@__DIR__, "WAGE71.csv")) |> DataFrame,
        :CONFIG => (; IDPL = 105)
    )

    r = simulate(CROPPController; config, stop=134u"d")

    visualize(r, :IDAY, [:TAGB, :WTU], kind=:line)
end