


# include("./particle.jl")

"""
* ls1: particle 1
* ls2: particle 2
* S: Total strangeness
* Q: Total charge
* iso: Total isospin (optional)
"""
function couple_channel(ls1, ls2, S, Q; iso=nothing)
    ch = String[]
    thre = Float64[]
    for i1 in ls1
        p1 = select_particle(i1)
        s1 = parse(Int64, p1[:S])
        q1 = parse(Int64, p1[:Q])
        I1 = parse_quantum_number(p1[:i])
        m1 = parse(Float64, p1[:mass])
        FA1 = p1[:FA_id]
        for i2 in ls2
            p2 = select_particle(i2)
            s2 = parse(Int64, p2[:S])
            q2 = parse(Int64, p2[:Q])
            I2 = parse_quantum_number(p2[:i])
            m2 = parse(Float64, p2[:mass])
            FA2 = p2[:FA_id]
            match = (S == s1 + s2 && Q == q1 + q2 && (isnothing(iso) || abs(I1 - I2) <= iso <= I1 + I2))
            if match
                push!(ch, "{$FA1,$FA2}")
                push!(thre, m1+m2)
            end
        end
    end
    idx = sortperm(thre)
    ch = ch[idx]
    return "{" * join(ch, ",") * "}"
end



function write_couple_channel(ls1::AbstractVector{String}, ls2::AbstractVector{String}, S::Int64, Q::Int64, name::AbstractString, path::AbstractString; iso=nothing, mode="w+", comment=nothing)
    sc = couple_channel(ls1, ls2, S, Q, iso=iso)
    open(path, mode) do f
        if !isnothing(comment)
            write(f, "(*$comment\n*)")
        end
        write(f, "$name=$sc\n")
    end
    return nothing
end