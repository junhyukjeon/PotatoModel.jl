using Cropbox
using CSV
using DataFrames
using PotatoModel
using Test
using TimeZones

@testset "PotatoModel" begin
    config = @config(
            :Calendar => :init => ZonedDateTime(1971, 4, 15, tz"UTC"),
            :Clock => :step => 1u"d",
            :WEATHR => :W => CSV.File(joinpath(@__DIR__, "WAGE71.csv")) |> DataFrame,
            :CONFIG => (; IDPL = 105)
        )

    r = simulate(Model; config, stop = 134u"d")
end