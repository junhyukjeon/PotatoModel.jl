using Cropbox
using CSV
using DataFrames
using PotatoModel
using Test

using PotatoModel: ASTRO, CROPP, LINTER, PENMAN, WATBALS, WEATHR, CONFIG

@system WATBALSController(ASTRO, CROPP, LINTER, PENMAN, WATBALS, WEATHR, CONFIG, Controller)

@testset "WATBALS" begin
    config = @config (
        :Calendar => :init => ZonedDateTime(1971, 4, 15, tz"UTC"),
        :Clock => :step => 1u"d",
        :WEATHR => :W => CSV.File(joinpath(@__DIR__, "WAGE71.csv")) |> DataFrame,
        :CONFIG => (; IDPL = 105)
)

    r = simulate(WATBALSController; config, stop = 134u"d")

    visualize(r, :IDAY, :TRAIN, kind=:line)
end