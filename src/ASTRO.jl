"""
This system calculates astronomical daylength and photoperiodically active day length.
Requires day of year and latitude.
"""
@system ASTRO begin
    
    "Declination of sun as function of day number"
    DEC(IDAY) => -asin(sin(23.45*pi/180)*cos(2*pi*(IDAY+10)/365)) ~ track

    # Intermediates #
    SINLD(LAT, DEC) => sin(pi/180*LAT)*sin(DEC) ~ track
    COSLD(LAT, DEC) => cos(pi/180*LAT)*cos(DEC) ~ track
    A(SINLD, COSLD) => SINLD/COSLD ~ track(min=-1, max=1)
    B(SINLD, COSLD) => (-sin(-4*pi/180)+SINLD)/COSLD ~ track(min=-1, max=1)

    "Daylength"
    DAYL(A) => 12*(1+2*asin(A)/pi) ~ track(u"hr")

    "Photoperiodically active daylength"
    DAYLP(B) => 12*(1+2*asin(B)/pi) ~ track(u"hr")

#-----------------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------------#

    "Latitude"
    LAT ~ hold # CONFIG
    "Julian day number"
    IDAY ~ hold # WEATHR

end
