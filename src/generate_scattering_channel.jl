


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

            iso_ok = isnothing(iso) ||
                     (abs(I1 - I2) <= iso <= I1 + I2 && isinteger(I1 + I2 - iso))

            match = (S == s1 + s2 && Q == q1 + q2 && iso_ok)
            if match
                push!(ch, "{$FA1,$FA2}")
                push!(thre, m1 + m2)
            end
        end
    end
    idx = sortperm(thre)
    ch = ch[idx]
    return CoupleChannelResult(channel="{" * join(ch, ",") * "}")
end



ISO_FAMILY = Dict(
    "mpi0" => "mpi", "mpip" => "mpi", "mpim" => "mpi",
    "mSigma0" => "mSigma", "mSigmap" => "mSigma", "mSigmam" => "mSigma",
    "mKm" => "mKbar", "mK0bar" => "mKbar", "mK0" => "mK", "mKp" => "mK",
    "mp" => "mN", "mn" => "mN",
    "meta" => "meta",
    "mLambda" => "mLambda",
    "mXi0" => "mXi", "mXim" => "mXi",
)

function scattering_channel(ls1, ls2, S, Q; iso=nothing)
    pairs = Tuple{String,String,Float64}[]
    for i1 in ls1
        p1 = select_particle(i1)
        s1 = parse(Int64, p1[:S]); q1 = parse(Int64, p1[:Q])
        I1 = parse_quantum_number(p1[:i]); m1 = parse(Float64, p1[:mass])
        FA1 = p1[:msym]
        for i2 in ls2
            p2 = select_particle(i2)
            s2 = parse(Int64, p2[:S]); q2 = parse(Int64, p2[:Q])
            I2 = parse_quantum_number(p2[:i]); m2 = parse(Float64, p2[:mass])
            FA2 = p2[:msym]
            match = (S == s1 + s2 && Q == q1 + q2 &&
                     (isnothing(iso) || abs(I1 - I2) <= iso <= I1 + I2))
            match && push!(pairs, (FA1, FA2, m1 + m2))
        end
    end

    if !isnothing(iso)
        grouped = Dict{Tuple{String,String}, Vector{Float64}}()
        order = Tuple{String,String}[]
        for (fa1, fa2, t) in pairs
            key = (get(ISO_FAMILY, fa1, fa1), get(ISO_FAMILY, fa2, fa2))
            if !haskey(grouped, key)
                grouped[key] = Float64[]
                push!(order, key)
            end
            push!(grouped[key], t)
        end
        ch = ["($k1, $k2)" for (k1, k2) in order]
        thre = [sum(grouped[k]) / length(grouped[k]) for k in order]
    else
        ch = ["($fa1, $fa2)" for (fa1, fa2, _) in pairs]
        thre = [t for (_, _, t) in pairs]
    end

    idx = sortperm(thre)
    ch = ch[idx]
    return ScatteringChannelResult(sc = "[" * join(ch, ", ") * "]")
end



@kwdef mutable struct CoupleChannelResult
    channel::String = ""
end

@kwdef mutable struct ScatteringChannelResult
    sc::String = ""
end

function Base.show(io::IO, channel::CoupleChannelResult)
    print(io, channel.channel)
end

function Base.show(io::IO, channel::ScatteringChannelResult)
    print(io, channel.sc)
end


function write_couple_channel(ls1::AbstractVector{String}, ls2::AbstractVector{String}, S::Int64, Q::Int64, name::AbstractString, path::AbstractString; iso=nothing, mode="w+", comment=nothing)
    sc = couple_channel(ls1, ls2, S, Q, iso=iso).channel
    open(path, mode) do f
        if !isnothing(comment)
            write(f, "(*$comment*)\n")
        end
        write(f, "$name=$sc\n")
    end
    return nothing
end