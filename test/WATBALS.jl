using Cropbox
using PotatoModel
using Test

using PotatoModel: WATBALS

@system WATBALSController(WATBALS, Controller) begin
    ES0 => 1 ~ preserve(parameter)
    ETC => 1 ~ preserve(parameter)
    RAIN => 1 ~ preserve(parameter)
    FINT => 1 ~ preserve(parameter)

    time(context.clock.time) ~ track(u"d")
end

@testset "WATBALS" begin
    r = simulate(WBALController; stop = 5u"d")
end