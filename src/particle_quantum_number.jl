


# include("./particle.jl")


function phase_factor(name::AbstractString)
    factor = 1
    if name == "pip" || name == "Km" || name == "Sigmap" || name == "Xim"
        factor = -1
    end
    return factor
end

function particle_quantum_number_info(particle::AbstractVector{String})
    pp = String[]

    for name in particle
        p = select_particle(name)
        name = p[:name]
        FA_id = p[:FA_id]
        factor = phase_factor(p[:name])
        Y = p[:Y]
        I = p[:i]
        I3 = p[:i3]
        push!(pp, "$FA_id->{$factor,{$Y,$I,$I3}} (*$name*)")
    end
    return pp
end

particle_quantum_number_info(["pip", "pim"])


function write_particle_quantum_number_info(particle::AbstractVector{String}, path::AbstractString)
    quan_info = particle_quantum_number_info(particle)
    quan_info = "{s={\n" * join(quan_info, ",\n") * "}}"
    open(path, "w+") do f
        write(f, "ParticleInfomation[SS_]:=Module[\n$quan_info,\nAssociation[s][SS]\n];")
    end
end
