"""
This system contains all the parameters for PotatoModel.
"""
@system CONFIG begin
    
    "Irrigation switch"
    IRRI => 1 ~ preserve(parameter) # 0 = off, 1 = on
    "Day of planting"
    IDPL => 50 ~ preserve(parameter)
    "Day of emergence"
    IDEM => 0 ~ preserve(parameter)
    "Atmospheric CO2 concentration"
    CO2 => 355 ~ preserve(parameter)
    SENSP => 1 ~ preserve(parameter)
    SENSW => 1 ~ preserve(parameter)
    SENSR => 1 ~ preserve(parameter)
    SENST => 0 ~ preserve(parameter)

    ## ASTRO ##
    "Latitude"
    LAT => 51.97 ~ preserve(parameter)

    ## CROPP ##
    "Total (above ground) crop dry weight at emergence"
    TAGBI => 60 ~ preserve(parameter, u"kg/ha") # Total (above ground) crop dry weight at emergence
    "Asymtotic maximum of harvest index"
    HIM => 0.88 ~ preserve(parameter) # Asymptotic maximum of harvest index
    "Initial slope of the harvest index curve (0.0015 (very late) to 0.0045 (very early))"
    HISLP => 0.0030 ~ preserve(parameter)
    "Start of tuber filling indicated by temperature sum"
    STTUB => 170 ~ preserve(parameter) # 
    "Dry matter content of storage organs (tubers)"
    DMSO => 0.21 ~ preserve(parameter)
    "Base temperature of sums for potato (C)"
    TBASE => 2 ~ preserve(parameter, u"°C")
    "Daylength effect switch"
    IDAYL => 0 ~ preserve(parameter) # 0 = off, 1 = on
    "Day length for maximum long day effect"
    DAYMAX => 20 ~ preserve(parameter, u"hr") # Day length for maximum long day effect (h)
    "Day length with no long day effect"
    DAYMIN => 10 ~ preserve(parameter, u"hr") # Day length with no long day effect (h)
    "Temperature sum for emergence of 50% of plants (sum above TBASE = 2)"
    TSUMEM => 285 ~ preserve(parameter, u"K") # Temperature sum for emergence of 50% of plants (sum above TBASE = 2)
    "Plant density"
    NPL => 4 ~ preserve(parameter, u"m^-2") # plant density

    ## LINTER ##
    "Initial light interception capacity per plant"
    FINT0 => 0.0139 ~ preserve(parameter, u"m^2") # Initial light interception capacity per plant (m2/plant)
    "Initial relative growth rate of light interception capacity"
    R0 => 0.0250 ~ preserve(parameter) # Initial relative growth rate of light interception capacity (C-1 d-1)
    "Duration of phase of decreasing light interception"
    DURE => 325 ~ preserve(parameter) # Duration of phase of decreasing light interception (C d)
    "Temperature sum required until 50% reduction of light interception"
    TS50 => 1250 ~ preserve(parameter) # Temperature sum required until 50% reduction of light interception (C d)

    ## PENMAN ##
    "Altitude"
    ALTI => 7 ~ preserve(parameter)
    "Albedo for water surface"
    REFCFW => 0.05 ~ preserve(parameter) # Water surface
    "Albedo for soil surface"
    REFCFS => 0.15 ~ preserve(parameter) # Soil surface
    "Albedo for canopy"
    REFCFC => 0.25 ~ preserve(parameter) # Canopy
    "Latent heat of evaporation of water"
    LHVAP => 2.45e6 ~ preserve(parameter, u"J/mm/m^2")
    "Stefan Boltzmann constant"
    STBC => 4.9e-3 ~ preserve(parameter, u"J/m^2/d/K")
    "Psychometric instrument constant"
    PSYCON => 0.000662 ~ preserve(parameter, u"K^-1")

    ## WATBALS ##
    "Soil moisture content at wilting point (pF= 4.2)"
    SMW => 0.100 ~ preserve(parameter, u"cm^3/cm^3")
    "Soil moisture content at field capacity (pF= 2.3)"
    SMFC => 0.350 ~ preserve(parameter, u"cm^3/cm^3")
    "Soil moisture content at saturation"
    SM0 => 0.450 ~ preserve(parameter, u"cm^3/cm^3")
    "Initial soil moisture content at planting or emergence"
    SMI => 0.350 ~ preserve(parameter, u"cm^3/cm^3")
    "Maximum rooting depth for potato crop"
    RDMCR => 50 ~ preserve(parameter, u"cm")
    "Maximum rooting depth determined by soil structure and layers"
    RDMSO => 150 ~ preserve(parameter, u"cm")
    "Average fraction of precipitation lost by runoff"
    RUNFR => 0 ~ preserve(parameter)
    "Crop-specific correction factor of potential transpiration"
    CFET => 1.15 ~ preserve(parameter)
    "Correction factor of time course of soil evaporation (between 1 and 4)"
    CFEV => 2.0 ~ preserve(parameter)

end