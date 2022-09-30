using Cropbox
using CSV
using DataFrames
using PotatoModel
using Test
using TimeZones

config = @config (
    :Calendar => :init => ZonedDateTime(1971, 4, 15, tz"UTC"),
    :Clock => :step => 1u"d",
    :WEATHR => :W => CSV.File(joinpath(@__DIR__, "WAGE71.csv")) |> DataFrame,
    :CONFIG => (;
        IDPL = 105,
        IRRI = 1,
        SMW = 0.100u"cm^3/cm^3",
        SMFC = 0.400u"cm^3/cm^3",
        SM0 = 0.450u"cm^3/cm^3",
        SMI = 0.400u"cm^3/cm^3",
        RDMCR = 50u"cm",
        RDMSO = 150u"cm",
        RUNFR = 0,
        CFET = 1.15,
        CFEV = 2.0
    )
)

# @testset "PotatoModel" begin
    r = simulate(Model;
    config,
    stop = 134u"d",
    target = [
        "IDAY",
        "TAGB",
        "WTU",
        "TDRAIN",
        "TIRR",
        "DIRR",
        "PERC",
        "SMACT",
        "SMCR",
        "WTOT",
        "WAVT",
        "TPAR",
        "TPARINT"
    ]
)
# end

# visualize(r, :DAYS, [:DWAT, :WBAL]; kind=:line)