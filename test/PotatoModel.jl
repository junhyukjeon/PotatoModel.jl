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
        :CONFIG => (; 
            IDPL = 105,
            FINT0 = 0.0139,
            R0 = 0.0250,
            DURE = 325,
            TS50 = 1250,
            HIM = 0.88,
            HISLP = 0.0030,
            STTUB = 170,
            DMSO = 0.21,
            TBASE = 2,
            IDAYL = 0,
            DAYMAX = 20,
            DAYMIN = 10,
            TSUMEM = 285,
            NPL = 4,
            SMW = 0.1,
            SMFC = 0.4,
            SM0 = 0.45,
            SMI = 0.4,
            RDMCR = 50,
            RDMSO = 150,
            RUNFR = 0,
            CFET  = 1.15,
            CFEV = 2.0
        )
    )

    r = simulate(Model; config, stop = 128u"d", target=[
        "IDAY", "WTU", "TAGB", "SMACT", "SMCR", "TRAIN", "TIRR", "TTRANS", "TESOIL", "TDRAIN", "TRUNOF", "WTOT", "WAVT", "TPARINT", "TPAR"])

end