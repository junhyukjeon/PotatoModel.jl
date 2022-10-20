"""
This system loads weather values from a csv format weather file.
"""
@system WEATHR begin

    calendar(context) ~ ::Calendar
    "Weather dataframe"
    W ~ provide(index=:DATE, init=calendar.date, parameter)
    
    "Day number"
    IDAY ~ drive::int(from=W, by=:DAY)

    "Daily total radiation"
    DTR ~ drive(from=W, u"J/m^2/d")

    "Minimum temperature"
    TMIN ~ drive(from=W, u"°C")

    "Maximum temperature"
    TMAX ~ drive(from=W, u"°C")

    "Vapor pressure"
    VAP ~ drive(from=W, u"mbar")

    "Wind"
    WIND ~ drive(from=W, u"m/s")

    "Precipitation"
    RAIN ~ drive(from=W, u"cm/d")

    "Average(midrange) daily temperature"
    TMPA(nounit(TMIN), nounit(TMAX)) => (TMIN + TMAX)/2 ~ track(u"°C")

end

