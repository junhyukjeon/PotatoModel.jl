using Cropbox
using CSV
using DataFrames
using PotatoModel
using Test

using PotatoModel: ASTRO, WEATHR, CONFIG

@system ASTROController(ASTRO, WEATHR, CONFIG, Controller)

# @testset "ASTRO" begin
    config = @config (
        :Calendar => :init => ZonedDateTime(1971, 4, 15, tz"UTC"),
        :Clock => :step => 1u"d",
        :WEATHR => :W => CSV.File(joinpath(@__DIR__, "WAGE71.csv")) |> DataFrame,
        :CONFIG => (; IDPL = 105)
    )

    r = simulate(ASTROController; config, stop=134u"d")

    visualize(r, :IDAY, [:SINLD, :COSLD], kind=:line)
    visualize(r, :IDAY, [:DAYL, :DAYLP], kind=:line)
# end