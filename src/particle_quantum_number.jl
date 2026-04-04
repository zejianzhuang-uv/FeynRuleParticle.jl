


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


function write_particle_quantum_number_info(particle::AbstractVector{String}, path::AbstractString; mode="w+")
    quan_info = particle_quantum_number_info(particle)
    quan_info = "{s={\n" * join(quan_info, ",\n") * "}}"
    open(path, mode) do f
        write(f, "ParticleInfomation[SS_]:=Module[\n$quan_info,\nAssociation[s][SS]\n];\n")
    end
end

function write_particle_isospin_multiplet(path::AbstractString; mode="a+")
    pion   = "pion->{" * join(["S[1]", "S[2]", "-S[1]"], ",") * "}"
    kaon   = "kaon->{" * join(["S[3]", "S[4]", "-S[4]", "-S[3]"], ",") * "}"
    eta    = "eta->{S[5]}"
    N      = "N->{" * join(["F[1]", "F[2]"], ",") * "}"
    Lambda = "Lambda->{F[3]}"
    Sigma  = "Sigma->{" * join(["F[4]", "F[5]", "F[6]"], ",") * "}"
    Xi     = "Xi->{" * join(["F[7]", "F[8]"], ",") * "}"
    me = join([pion, kaon, eta], ",")
    ba = join([N, Lambda, Sigma, Xi], ",")
    open(path, mode) do f
        write(f, "IsospinMesonMultiplet[SS_]:=Association[{$me}][SS]\n")
        write(f, "IsospinBaryonMultiplet[SS_]:=Association[{$ba}][SS]\n")
    end
end


