module FeynRuleParticle

export write_field_info, write_params_info, write_particle_quantum_number_info, couple_channel, write_particle_isospin_multiplet, write_couple_channel, scattering_channel, scattering_channel_MMA

include("./FeynRule_info.jl")
include("./particle_quantum_number.jl")
include("./generate_scattering_channel.jl")



end
