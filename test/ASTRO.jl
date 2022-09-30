using Cropbox
using PotatoModel
using Test

@system ASTROController(ASTRO, Controller) begin
    # Getting IDAY from weather data file
    # w: weather_data ~ provide(index=:DATE, init)

    # Time variable to keep its track
    time(context.clock.time) ~ track(u"d")
end

config = @config (
    :ASTRO => (;
        IDAY = 1,
            
    ),
)
