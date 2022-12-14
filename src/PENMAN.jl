"""
This subroutine calculates atmospheric transmission, potential evaporation
from a free water surface, a bare soil surface (ES0), and the potential
of a closed crop canopy (ET0).
"""
@system PENMAN begin

    "Correction coefficient for evapo-transpiration based on atmospheric CO2 concentration"
    CCET => ([
        40 => 0,
        355 => 1.00,
        710 => 1.20,
        1000 => 1.30,
        2000 => 1.30
    ]) ~ interpolate

#-----------------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------#

    "Daily temperature range"
    TDIF(nounit(TMIN), nounit(TMAX)) => TMAX - TMIN ~ track
    TDIF1(TDIF) => (TDIF - 12)/4 ~ track(min=0, max=1) # Intermediate

    "Coefficient Bu in wind function"
    BU(TDIF1) => 0.54 + 0.35*TDIF1 ~ track

    "Barometric pressure (mbar)"
    PBAR(ALTI, nounit(TMPA)) => 1013*exp(-0.034*ALTI/(TMPA+273)) ~ track(u"mbar")

    "Psychrometric constant (mbar/K)"
    GAMMA(PSYCON, PBAR) => PSYCON * PBAR ~ track(u"mbar/K")

    "Saturated vapor pressure (mbar) (Goudriaan equation)"
    SVAP(nounit(TMPA)) => 6.10588 * exp(17.32491 * TMPA / (TMPA + 238.102)) ~ track(u"mbar")

    "Measured vapor limit (mbar)"
    VAPLIM(VAP, SVAP) => min(VAP, SVAP) ~ track(u"mbar")

    "Slope of SVAP-temperature curve (mbar/K)"
    DELTA(SVAP, nounit(TMPA)) => 238.102 * 17.32491 * SVAP / (TMPA + 238.102)^2 * u"K^-1" ~ track(u"mbar/K")

    AOB(SINLD, COSLD) => SINLD/COSLD ~ track(min=-1, max=1)
    DSINB(nounit(DAYL), SINLD, COSLD, AOB) => 3600*(DAYL*SINLD + 24*COSLD*sqrt(1-AOB*AOB)/pi) ~ track

    "Solar Constant"
    SC(IDAY) => 1370*(1+0.033*cos(2*pi*IDAY/365)) ~ track

    "Daily extraterrestrial radiation"
    ANGOT(SC, DSINB) => max(0.0001, SC*DSINB) ~ track

    "Actual daily total irradiation"
    AVRAD(ANGOT, nounit(DTR)) => min(0.8*ANGOT, DTR) ~ track(u"J/m^2/d")

    "Atmospheric transmission"
    ATMTR(AVRAD, ANGOT) => AVRAD/ANGOT ~ track(init=0.5, u"J/m^2/d")

    RELSSD(nounit(ATMTR)) => (ATMTR - 0.2)/0.56 ~ track(min=0, max=1)

    RB(STBC, nounit(TMPA), (nounit(VAPLIM)), RELSSD) => STBC*(TMPA+273)^4*u"K"*(0.56-0.079*sqrt(VAPLIM))*(0.1+0.9*RELSSD) ~ track(u"J/m^2/d")

    "Net absorbed radiation of water surface"
    RNW(AVRAD, REFCFW, RB) => AVRAD*(1 - REFCFW) - RB ~ track(u"J/m^2/d")

    "Net absorbed radiation of the soil surface"
    RNS(AVRAD, REFCFS, RB) => AVRAD*(1 - REFCFS) - RB ~ track(u"J/m^2/d")

    "Net absorbed radiation of the canopy"
    RNC(AVRAD, REFCFC, RB) => AVRAD*(1 - REFCFC) - RB ~ track(u"J/m^2/d")

    "Evaporative demand of the atmosphere"
    EA(nounit(SVAP), nounit(VAPLIM), BU, nounit(WIND)) => 0.26*(SVAP - VAPLIM)*(0.5 + BU*WIND)*u"mm/d" ~ track(u"mm/d")

    "Evaporative demand of the atmosphere"
    EAC(nounit(SVAP), nounit(VAPLIM), BU, nounit(WIND)) => 0.26*(SVAP - VAPLIM)*(1.0 + BU*WIND)*u"mm/d" ~ track(u"mm/d")

    # Penman formula (1948) #
    E0(DELTA, RNW, LHVAP, GAMMA, EA) => 0.1u"cm/mm"*(DELTA*(RNW/LHVAP) + GAMMA*EA)/(DELTA + GAMMA) ~ track(u"cm/d")
    ES0(DELTA, RNS, LHVAP, GAMMA, EA) => 0.1u"cm/mm"*(DELTA*(RNS/LHVAP) + GAMMA*EA)/(DELTA + GAMMA) ~ track(u"cm/d")
    ET0(DELTA, RNC, LHVAP, GAMMA, EAC) => 0.1u"cm/mm"*(DELTA*(RNC/LHVAP) + GAMMA*EAC)/(DELTA + GAMMA) ~ track(u"cm/d")

    "Corrected potential evapo-transpiration"
    ETC(ET0, CCET, CO2) => ET0 * CCET(CO2) ~ track(u"cm/d")

#-----------------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------#
    
    "Altitude"
    ALTI ~ hold #CONFIG
    "Atmospheric CO2"
    CO2 ~ hold #CONFIG
    "Albedo for water surface"
    REFCFW ~ hold #CONFIG
    "Albedo for soil surface"
    REFCFS ~ hold #CONFIG
    "Albedo for canopy"
    REFCFC ~ hold #CONFIG
    "Latent heat of evaporation of water"
    LHVAP ~ hold #CONFIG
    "Stefan Boltzmann constant"
    STBC ~ hold #CONFIG
    "Psychometric instrument constant"
    PSYCON ~ hold #CONFIG
    "Daylength"
    DAYL ~ hold #ASTRO
    SINLD ~ hold #ASTRO
    COSLD ~ hold #ASTRO
    "Daily minimum temperature"
    TMIN ~ hold #WEATHR
    "Daily maximum temperature"
    TMAX ~ hold #WEATHER
    "Daily midrange temperature"
    TMPA ~ hold #WEATHR
    "Vapor pressure"
    VAP ~ hold
    "Wind"
    WIND ~ hold
    "Daily total radiation"
    DTR ~ hold
    "Day number"
    IDAY ~ hold

end