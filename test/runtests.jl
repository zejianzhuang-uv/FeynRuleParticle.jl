using FeynRuleParticle
using Test

@testset "FeynRuleParticle.jl" begin
    MB = ["pip", "pi0", "Kp", "K0", "eta",
    "p", "n", "Lambda", "Sigmap", "Sigma0", "Sigmam", "Xi0", "Xim"]
    file = "./particle.txt"
    write_field_info(MB, file)
    write_particle_quantum_number_info(MB, "particleinfo.txt")
end
