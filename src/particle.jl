

function parse_quantum_number(s::AbstractString)
    parts = split(s, '/')
    length(parts) == 2 ? parse(Float64, parts[1]) / parse(Float64, parts[2]) : parse(Float64, s)
end

function Hypercharge(S::AbstractString, B::AbstractString)
    Y = parse_quantum_number(S) + parse_quantum_number(B)
    return trunc(Int64, Y) |> string
end

function Charge(i3::AbstractString, Y::AbstractString)
    Q = parse_quantum_number(i3) + parse_quantum_number(Y) / 2
    return trunc(Int64, Q) |> string
end


function meson_octet(name::AbstractString)
    if name == "pip" # u dbar
        m = "139.6"
        S = "0"
        i = "1"
        i3 = "1"
        FA_id = "S[1]"
        selfcharged = "False"
        AntiParticleName = "pim"
    elseif name == "pim" # ubar d
        m = "139.6"
        S = "0"
        i = "1"
        i3 = "-1"
        FA_id = "-S[1]"
        selfcharged = "False"
        AntiParticleName = "pip"
    elseif name == "pi0" # uubar
        m = "135"
        S = "0"
        i = "1"
        i3 = "0"
        FA_id = "S[2]"
        selfcharged = "True"
        AntiParticleName = "pi0"
    elseif name == "Kp" # u sbar
        m = "494"
        S = "1"
        i = "1/2"
        i3 = "1/2"
        FA_id = "S[3]"
        selfcharged = "False"
        AntiParticleName = "Km"
    elseif name == "Km"
        m = "494"
        S = "-1"
        i = "1/2"
        i3 = "-1/2"
        FA_id = "-S[3]"
        selfcharged = "False"
        AntiParticleName = "Kp"
    elseif name == "K0" # d sbar
        m = "498"
        S = "1"
        i = "1/2"
        i3 = "-1/2"
        FA_id = "S[4]"
        selfcharged = "False"
        AntiParticleName = "K0bar"
    elseif name == "K0bar"
        m = "498"
        S = "-1"
        i = "1/2"
        i3 = "1/2"
        FA_id = "-S[4]"
        selfcharged = "False"
        AntiParticleName = "K0"
    elseif name == "eta"
        m = "548"
        S = "0"
        i = "0"
        i3 = "0"
        FA_id = "S[5]"
        selfcharged = "True"
        AntiParticleName = "eta"
    end
    B = "0"
    Y = Hypercharge(S, B)
    Q = Charge(i3, Y)

    info = Dict{Symbol, String}(
        :name => name,
        :mass => m,
        :Y => Y,
        :Q => Q,
        :S => S,
        :i => i,
        :i3 => i3,
        :FA_id => FA_id,
        :selfcharged => selfcharged,
        :PropagatorType => "D",
        :AntiParticleName => AntiParticleName
    )
    return info
end


function baryon_octet(name::AbstractString)
    if name == "p" # uud
        m = "938"
        S = "0"
        i = "1/2"
        i3 = "1/2"
        FA_id = "F[1]"
    elseif name == "n"
        m = "940"
        S = "0"
        i = "1/2"
        i3 = "-1/2"
        FA_id = "F[2]"
    elseif name == "Lambda" # uds
        m = "1115"
        S = "-1"
        i = "0"
        i3 = "0"
        FA_id = "F[3]"
    elseif name == "Sigmap"
        m = "1189"
        S = "-1"
        i = "1"
        i3 = "1"
        FA_id = "F[4]"
    elseif name == "Sigma0"
        m = "1193"
        S = "-1"
        i = "1"
        i3 = "0"
        FA_id = "F[5]"
    elseif name == "Sigmam"
        m = "1197"
        S = "-1"
        i = "1"
        i3 = "-1"        
        FA_id = "F[6]"
    elseif name == "Xi0" # uss 
        m = "1315"
        S = "-2"
        i = "1/2"
        i3 = "1/2"
        FA_id = "F[7]"
    elseif name == "Xim" # dss
        m = "1321"
        S = "-2"
        i = "1/2"
        i3 = "-1/2"
        FA_id = "F[8]"
    end
    B = "1"
    Y = Hypercharge(S, B)
    Q = Charge(i3, Y)

    info = Dict{Symbol, String}(
        :name => name,
        :mass => m,
        :Y => Y,
        :Q => Q,
        :S => S,
        :i => i,
        :i3 => i3,
        :FA_id => FA_id,
        :selfcharged => "False",
        :PropagatorType => "Straight",
        :AntiParticleName => name * "bar"
    )
    return info
end

