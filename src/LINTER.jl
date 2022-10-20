"""
This system calculates seasonal course of fractional light interception.
"""
@system LINTER begin
    
    TSULE1GT0(TSULE1) => (TSULE1 > 0u"K") ~ flag # flag for checking temperature sum

    "Light interception during the phase of leaf area expansion"
    FINTL(NPL, FINT0, R0, nounit(TSULE1)) => begin
        NPL * FINT0 * exp(R0*TSULE1) / (NPL*FINT0*exp(R0*TSULE1) + 1 - NPL*FINT0)
    end ~ track(when=(TSULE1GT0))

    "Light interception during the phase of senescence of the foliage"
    FINTS(nounit(TSULE2), TS50, DURE) => begin
        0.5 - (TSULE2 - TS50) / DURE
    end ~ track(when=(TSULE1GT0), min=0, max=1)

    "Fractional light interception of the canopy"
    FINT(FINTL, FINTS, TSULE1GT0) => begin
        if TSULE1GT0
            min(FINTL, FINTS)
        else
            0
        end
    end ~ track

#-----------------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------#

    "Initial light interception capacity per plant"
    FINT0 ~ hold
    "Initial relative growth rate of light interception capacity"
    R0 ~ hold
    "Duration of phase of decreasing light interception"
    DURE ~ hold
    "Temperature sum required until 50% reduction of light interception"
    TS50 ~ hold
    "Plant density (per m^2)"
    NPL ~ hold
    "Temperature sum after emergence of foliage (without long day effect)"
    TSULE1 ~ hold
    "Temperature sum after emergence of foliage (with long day effect)"
    TSULE2 ~ hold

end