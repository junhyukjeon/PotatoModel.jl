using Cropbox
using PotatoModel
using Test

using PotatoModel: WEATHR

@system WEATHRController(WEATHR, Controller)

@testset "WEATHR" begin
    config = @config(
            :Calendar => :init => ZonedDateTime(1971, 4, 15, tz"UTC"),
            :Clock => :step => 1u"d",
            :WEATHR => :W => CSV.File(joinpath(@__DIR__, "WAGE71.csv")) |> DataFrame)

    r = simulate(WEATHRController; config, stop=134u"d")

    visualize(r, :IDAY, :RAIN, kind=:line)
end