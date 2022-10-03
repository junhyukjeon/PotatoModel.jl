using Cropbox
using PotatoModel
using Test

using PotatoModel: CONFIG

@system CONFIGController(CONFIG, Controller)

@testset "CONFIG" begin
    simulate(CONFIGController)
end