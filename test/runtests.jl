using FeynRuleParticle
using Test

@testset "FeynRuleParticle.jl" begin
    MB = ["pip", "pi0", "Kp", "K0", "eta",
    "p", "n", "Lambda", "Sigmap", "Sigma0", "Sigmam", "Xi0", "Xim"]
    file = "./particle.txt"
    write_field_info(MB, file)
    write_particle_quantum_number_info(MB, "particleinfo.txt")
    meson = ["pip", "pim", "pi0", "Kp", "Km", "K0", "K0bar", "eta"]
    baryon = ["p", "n", "Lambda", "Sigmap", "Sigma0", "Sigmam", "Xi0", "Xim"]
    couple_channel(meson, baryon, -1, 0) |> println
    couple_channel(meson, baryon, -1, 0, iso=0) |> println
    write_particle_isospin_multiplet("channel.wl")
end
