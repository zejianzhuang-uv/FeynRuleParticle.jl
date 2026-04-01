using FeynRuleParticle
using Test

@testset "FeynRuleParticle.jl" begin
    MB = ["pip", "pim", "pi0", "Kp", "Km", "K0", "K0bar", "eta",
    "p", "n", "Lambda", "Sigmap", "Sigma0", "Sigmam", "Xi0", "Xim"]
    file = "./particle.txt"
    write_field_info(MB, file)
end
