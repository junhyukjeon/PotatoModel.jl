"""
This system simulates the soil water status in the maximum effective        
rooted zone. It takes into account soil surface evaporation, crop transpiration,
precipitation, surface runoff, irrigation, and drainage to the sub-soil.    
"""
@system WATBALS begin

    "Maximum rooting depth"
    RDM(RDMSO, RDMCR) => min(RDMSO, RDMCR) ~ preserve(parameter, u"cm")
    
    "Initial total available water in maximum rooted zone"
    WAVTI(RDM, SMACT, SMW) => RDM * (SMACT - SMW) ~ preserve(parameter, u"cm")

    "Available water at field capacity"
    WAVFC(RDM, SMFC, SMW) => RDM * (SMFC - SMW) ~ preserve(parameter, u"cm")

    "Initial actual soil moisture content"
    SMACTI(SMW, SMI, SMFC) => max(SMW, min(SMI, SMFC)) ~ preserve(parameter)
    RDMSMACTI(SMACTI, RDM) => RDM * SMACTI ~ preserve(parameter, u"cm")

#-------------------------------------------------------------------------#
#-------------------------------------------------------------------------#
       
    "Actual soil moisture content"
    SMACT(WTOT, RDM) => WTOT/RDM ~ track(u"cm^3/cm^3")

    "Irrigation"
    RIRR(DIRR) => DIRR ~ track(min=0, max=1, u"cm/d")

    "Percolation"
    PERC(RUNFR, RAIN, RIRR) => (1 - RUNFR) * RAIN + RIRR ~ track(u"cm/d")

    "Water loss by surface runoff"
    RUNOF(RUNFR, RAIN) => RUNFR * RAIN ~ track(u"cm/d")

    "Maximum transpiration rate"
    TRMAX(CFET, ETC, FINT) => CFET * ETC * FINT ~ track(u"cm/d")

    SWDEP(nounit(ETC)) => 1/(0.76 + 1.5*ETC) - 0.2 ~ track(min=0.10, max=0.95)
    SMCR(SWDEP, SMFC, SMW) => (1 - SWDEP) * (SMFC - SMW) + SMW ~ track
    RDRY(SMACT, SMW, SMCR) => (SMACT - SMW) / (SMCR - SMW) ~ track(min=0, max=1)
    "Actual transpiration"
    TRA(RDRY, TRMAX) => RDRY * TRMAX ~ track(u"cm/d")


    "Maximum soil evaporation rate as function of light interception"
    EVMAX(ES0, FINT) => ES0 * (1 - FINT) ~ track(u"cm/d")

    DSLR(DSLR, PERC) => ((PERC >= 1u"cm/d") ? 1 : (DSLR + 1)) ~ track(init=3)
    EVMAXINT(DSLR) => sqrt(DSLR) - sqrt(DSLR - 1) ~ track(min=0, max=1)
    EVMAXT(EVMAX, EVMAXINT, CFEV) => EVMAX * EVMAXINT * CFEV ~ track(u"cm/d")
    "Actual soil evaporation rate"
    EVA(EVMAX, EVMAXT, PERC) => ((PERC >= 1u"cm/d") ? EVMAX : min(EVMAX, EVMAXT + PERC)) ~ track(u"cm/d")


    "Effective percolation"
    PERC1(PERC, EVA, TRA) => PERC - EVA - TRA ~ track(u"cm/d")

    "Water holding capacity of maximum rooted zone"
    CAP(SMFC, SMACT, RDM) => (SMFC - SMACT) * RDM ~ track(u"cm")

    "Drainage"
    DRAIN(CAP, PERC1) => begin 
        if CAP*u"d^-1" <= PERC1
            PERC1 - CAP*u"d^-1"
        else
            0
        end
    end ~ track(u"cm/d")

    "Daily demand for irrigation water"
    DIRR(IRRI, SMACT, SMCR, WAVFC, WAVT) => begin
        if (IRRI == 1) && (SMACT <= (SMCR + 0.02))
            0.7 * (WAVFC - WAVT) * u"d^-1"
        else
            0
        end
    end ~ track(u"cm/d")

    "Change in total water and available water"
    DWAT(PERC, EVA, TRA, DRAIN) => PERC - EVA - TRA - DRAIN ~ track(u"cm/d")

#------------------------------------------------------------------------------#
#------------------------------------------------------------------------------#
    
    "Cumulative drainage"
    TDRAIN(DRAIN) => DRAIN ~ accumulate(u"cm")

    "Cumulative precipitation"
    TRAIN(RAIN) => RAIN ~ accumulate(u"cm")

    "Cumulative surface runoff"
    TRUNOF(RUNOF) => RUNOF ~ accumulate(u"cm")

    "Cumulative irrigation"
    TIRR(RIRR) => RIRR ~ accumulate(u"cm")

    "Cumulative soil evaporation"
    TESOIL(EVA) => EVA ~ accumulate(u"cm")

    "Cumulative crop transpiration"
    TTRANS(TRA) => TRA ~ accumulate(u"cm")

    "Total water in maximum rooted zone"
    WTOT(DWAT) => DWAT ~ accumulate(init=(RDMSMACTI), u"cm")

    "Total available water in maximum rooted zone"
    WAVT(DWAT) => DWAT ~ accumulate(init=WAVTI, u"cm")

#----------------------------------------------------------------------#
#----------------------------------------------------------------------#
    
    "Soil moisture content at wilting point (pF= 4.2) (CONFIG)"
    SMW ~ hold
    "Soil moisture content at field capacity (pF= 2.3) (CONFIG))"
    SMFC ~ hold
    "Soil moisture content at saturation (from CONFIG)"
    SM0 ~ hold
    "Initial soil moisture content at planting or emergence (CONFIG)"
    SMI ~ hold
    "Maximum rooting depth for potato crop (CONFIG)"
    RDMCR ~ hold
    "Maximum rooting depth determined by soil structure and layers (CONFIG)"
    RDMSO ~ hold
    "Average fraction of precipitation lost by runoff (CONFIG)"
    RUNFR ~ hold
    "Crop-specific correction factor of potential transpiration (CONFIG)"
    CFET ~ hold
    "Correction factor of time course of soil evaporation (between 1 and 4) (CONFIG)"
    CFEV ~ hold
    "Potential evaporation from soil surface"
    ES0 ~ hold # From PENMAN
    "Corrected potential evapo-transpiration (PENMAN)"
    ETC ~ hold
    "Precipitation (WEATHR)"
    RAIN ~ hold # From WEATHR
    "Fractional light interception of canopy (LINTER)"
    FINT ~ hold
    
end