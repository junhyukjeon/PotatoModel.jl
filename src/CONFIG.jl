"""
This system contains all parameters for PotatoModel.
"""
@system CONFIG begin
    ## INPUT ##
    IRRI => 1 ~ preserve(parameter) # 0 = off, 1 = on
    IDPL => 50 ~ preserve(parameter)
    IDEM => 0 ~ preserve(parameter)
    CO2 => 355 ~ preserve(parameter)
    SENSP => 1 ~ preserve(parameter)
    SENSW => 1 ~ preserve(parameter)
    SENSR => 1 ~ preserve(parameter)
    SENST => 0 ~ preserve(parameter)

    ## ASTRO ##
    LAT => 51.97 ~ preserve(parameter)

    ## CROPP ##
    TAGBI => 60 ~ preserve(parameter, u"kg/ha") # Total (above ground) crop dry weight at emergence
    HIM => 0.88 ~ preserve(parameter) # Asymptotic maximum of harvest index
    HISLP => 0.0030 ~ preserve(parameter)
    STTUB => 170 ~ preserve(parameter) # 
    DMSO => 0.21 ~ preserve(parameter)
    TBASE => 2 ~ preserve(parameter, u"°C")
    IDAYL => 0 ~ preserve(parameter) # 0 = off, 1 = on
    DAYMAX => 20 ~ preserve(parameter, u"hr") # Day length for maximum long day effect (h)
    DAYMIN => 10 ~ preserve(parameter, u"hr") # Day length with no long day effect (h)
    TSUMEM => 285 ~ preserve(parameter, u"K") # Temperature sum for emergence of 50% of plants (sum above TBASE = 2)
    NPL => 4 ~ preserve(parameter, u"m^-2") # plant density

    ## LINTER ##
    FINT0 => 0.0139 ~ preserve(parameter, u"m^2") # Initial light interception capacity per plant (m2/plant)
    R0 => 0.0250 ~ preserve(parameter) # Initial relative growth rate of light interception capacity (C-1 d-1)
    DURE => 325 ~ preserve(parameter) # Duration of phase of decreasing light interception (C d)
    TS50 => 1250 ~ preserve(parameter) # Temperature sum required until 50% reduction of light interception (C d)

    ## PENMAN ##
    ALTI => 7 ~ preserve(parameter)
    REFCFW => 0.05 ~ preserve(parameter) # Water surface
    REFCFS => 0.15 ~ preserve(parameter) # Soil surface
    REFCFC => 0.25 ~ preserve(parameter) # Canopy
    LHVAP => 2.45e6 ~ preserve(parameter, u"J/mm/m^2")
    STBC => 4.9e-3 ~ preserve(parameter, u"J/m^2/d/K")
    PSYCON => 0.000662 ~ preserve(parameter, u"K^-1")

    ## WATBALS ##
    SMW => 0.100 ~ preserve(parameter, u"cm^3/cm^3")
    SMFC => 0.350 ~ preserve(parameter, u"cm^3/cm^3")
    SM0 => 0.450 ~ preserve(parameter, u"cm^3/cm^3")
    SMI => 0.350 ~ preserve(parameter, u"cm^3/cm^3")
    RDMCR => 50 ~ preserve(parameter, u"cm")
    RDMSO => 150 ~ preserve(parameter, u"cm")
    RUNFR => 0 ~ preserve(parameter)
    CFET => 1.15 ~ preserve(parameter)
    CFEV => 2.0 ~ preserve(parameter)
end