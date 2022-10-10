# This system calculates dry matter increase as a function of
# intercepted radiation, light use efficiency, and water availability
@system CROPP begin

    PL(IDPL, IDAY) => (IDAY >= IDPL) ~ flag

    "Days since planting"
    DAYS => 1 ~ accumulate::int(when=PL, u"d")

    "Light use efficiency for biomass production as function of temperature sum since emergence"
    LUETB => [
           0 => 3,
        1000 => 3,
        2000 => 3,
    ] ~ interpolate

    "Reduction of light use efficiency as function of average day temperature (Celcius)"
    TMPTB => [
        0.00 => 0.01,
        2.00 => 0.01,
        10.00 => 0.50,
        16.00 => 1.00,
        24.00 => 1.00,
        30.00 => 0.50,
        35.00 => 0.01,
    ] ~ interpolate

    "Correction of light use efficiency as function of atmospheric CO2 concentration"
    COTB => [
        40 => 0.01
        355 => 1.00
        710 => 1.20
        1000 => 1.30
        2000 => 1.30
    ] ~ interpolate

#-----------------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------#

    "Daily photosynthetically active radiation"
    PAR(AVRAD) => AVRAD/1.0e6*u"MJ/J" * 0.5 ~ track(u"MJ/m^2/d")

    "Reduction of development rate until tuber initiation by day length"
    FRDAY(DAYLP, DAYMIN, DAYMAX) => (DAYLP - DAYMIN) / (DAYMAX - DAYMIN) ~ track(min=0, max=1)

    RDAYL(IDAYL, FRDAY) => begin
        if IDAYL == 1 && !TUB
            1 - 0.5 * FRDAY
        else
            1
        end
    end ~ track

    DTSULL(TMPA, TBASE) => (TMPA - TBASE) * u"d^-1" ~ track(min=0, max=18, u"K/d")

    DTSUL(TMPA, TBASE) => (TMPA - TBASE) * u"d^-1" ~ track(min=0, u"K/d")

    TEFF(TMPA, TBASE) => begin
        (TMPA - 13u"°C") >= 0u"°C" ? (TMPA - TBASE) : (29u"°C" - TMPA)
    end ~ track(u"K")

    DTSUT(TEFF) => TEFF*u"d^-1" ~ track(min=0, max=11, u"K/d")

    DTSULP(DTSULL) => DTSULL ~ track(when=PL, u"K/d")

    DTSULE1(DTSUL) => DTSUL ~ track(when=EM, u"K/d")
    DTSULE2(DTSUL, RDAYL) => DTSUL * RDAYL ~ track(when=EM, u"K/d")
    DTSUTE(DTSUT, RDAYL) => DTSUT * RDAYL ~ track(when=EM, u"K/d")

    "Temperature sum after planting"
    TSULP(DTSULP) => DTSULP ~ accumulate(u"K")

    "Temperature sum after emergence of foliage (without long day effect)"
    TSULE1(DTSULE1) => DTSULE1 ~ accumulate(u"K")
    TSULE1INT(nounit(TSULE1)) => TSULE1 ~ track(max=2000)

    "Temperature sum after emergence of foliage (with long day effect)"
    TSULE2(DTSULE2) => DTSULE2 ~ accumulate(u"K")

    "Temperature sum after emergence of tuber"
    TSUTE(DTSUTE) => DTSUTE ~ accumulate(u"K")

    "Light use efficiency"
    LUE(LUETB, TSULE1INT) => LUETB(TSULE1INT) ~ track

    RCO(COTB, CO2) => COTB(CO2) ~ track

    DTEMP(nounit(TMIN), nounit(TMAX)) => TMAX - 0.25*(TMAX - TMIN) ~ track
    RTMP(TMPTB, DTEMP) => TMPTB(DTEMP) ~ track

    PARINT(FINT, PAR) => FINT * PAR ~ track(u"MJ/m^2/d")
    GRT(RTMP, RCO, LUE, RDRY, PARINT) => RTMP*RCO*LUE*PARINT*10*RDRY*u"kg/ha/MJ*m^2" ~ track(u"kg/ha/d")

    "Harvest Index"
    HI(HIM, HISLP, nounit(TSUTE), STTUB) => begin
        max(0, HIM * (1 - exp(-HISLP * (TSUTE - STTUB) / HIM)))
    end ~ track

    "Start of Tuber Filling"
    TUB(nounit(TSUTE), STTUB) => (TSUTE >= STTUB) ~ flag
    # IDTUB(IDAY) => IDAY ~ preserve(when=TUB)

    "Total photosynthetically active radiation (MJ/m2)"
    TPAR(PAR) => PAR ~ accumulate(u"MJ/m^2")

    "Total intercepted radiation (MJ/m2)"
    TPARINT(PARINT) => PARINT ~ accumulate(u"MJ/m^2")

    "Total above ground biomass (kg DM / ha)"
    TAGB(GRT) => GRT ~ accumulate(init=TAGBI, u"kg/ha")

    "Tuber biomass"
    WTU(HI, TAGB) => HI * TAGB ~ track(u"kg/ha")

    EM(PL, TSULP, TSUMEM) => (PL && (TSULP >= TSUMEM)) ~ flag

    # "Day of emergence"
    # IDEM(IDAY, EM) => IDAY ~ preserve(when=EM)

#-----------------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------#

    "Day of planting"
    IDPL ~ hold #CONFIG
    "Total (above ground) crop dry weight at emergence"
    TAGBI ~ hold #CONFIG
    "Asymptotic maximum of harvest index"
    HIM ~ hold #CONFIG
    "Initial slope of the harvest index curve (0.0015 (very late) to 0.0045 (very early))"
    HISLP ~ hold #CONFIG
    "Start of tuber filling indicated by temperature sum"
    STTUB ~ hold #CONFIG
    "Dry matter content of storage organs (tubers) (-)"
    DMSO ~ hold #CONFIG
    "Base temperature of sums for potato (C)"
    TBASE ~ hold #CONFIG
    " Atmospheric CO2 concentration"
    CO2 ~ hold #CONFIG
    "Daylength effect on/off"
    IDAYL ~ hold #CONFIG
    "Day length for maximum long day effect"
    DAYMAX ~ hold #CONFIG
    "Day length with no long day effect"
    DAYMIN ~ hold #CONFIG
    "Temperature sum for emergence of 50% of plants (sum above TBASE = 2)"
    TSUMEM ~ hold #CONFIG
    "Plant density"
    NPL  ~ hold #CONFIG
    "Day number"
    IDAY ~ hold #WEATHR
    "Actual daily total radiation"
    AVRAD ~ hold #PENMAN
    "Fractional light interception of the canopy"
    FINT ~ hold #LINTER
    "Daily maximum temperature"
    TMAX ~ hold #WEATHR
    "Daily minimum temperature"
    TMIN ~ hold #WEATHR
    "Daily temperature range (WEATHR)"
    TMPA ~ hold #WEATHR
    "Photoperiodically active daylength (ASTRO)"
    DAYLP ~ hold #ASTRO
    "Reduction of transpiration due to drought (WATBALS)"
    RDRY ~ hold #WATBALS
    
end