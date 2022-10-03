using Cropbox
using PotatoModel
using Test

using PotatoModel: ASTRO, PENMAN, WEATHR, CONFIG

@system PENMANController(ASTRO, PENMAN, WEATHR, CONFIG, Controller)

@testset "PENMAN" begin
    config = @config(
        :Calendar => :init => ZonedDateTime(1971, 4, 15, tz"UTC"),
        :Clock => :step => 1u"d",
        :WEATHR => :W => CSV.File(joinpath(@__DIR__, "WAGE71.csv")) |> DataFrame,
        :CONFIG => (; IDPL = 105)
    )

    r = simulate(PENMANController; config, stop=134u"d")

    visualize(r, :IDAY, :AVRAD, kind=:line)
    visualize(r, :IDAY, [:ES0, :ETC], kind=:line)
end