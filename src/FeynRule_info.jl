


include("./particle.jl")




function write_field_info(particle_list::Vector{String}, file::String; mode="w+")
    finf = [_field_info(p) for p in particle_list]
    finf = join(finf, ",\n\n(******************************)\n\n")
    write_author_info(file, mode=mode)
    open(file, "a+") do ff
        write(ff, "M\$ClassesDescription = {\n\n")
        write(ff, finf)
        write(ff, "\t};\n\n\n\n")
    end
    
    return nothing
end

function write_author_info(file; mode="w+")
    open(file, mode) do ff
        write(ff, "M\$Information = {\nAuthor -> \"Zejian Zhuang\",\nVersion -> 1.0}\n\n\n\n")
    end
    return nothing
end


function _field_info(particle)
    p = select_particle(particle)
    t = "$(p[:FA_id]) == {\n\tClassName -> $(p[:name]),\n\tSelfConjugate -> $(p[:selfcharged]),\n\tMass -> {m$(p[:name]), $(p[:mass])},\n\tWidth -> 0\n\t}"
    return t
end



function write_params_info(name_list::Vector{String}, tex_name_list::Vector{String}, file::String)
    open(file, "a+") do ff
        write(ff, "M\$Parameters = {\n")
    end
    i = 1
    nmax = length(name_list)
    for (name, tn) in zip(name_list, tex_name_list)
        open(file, "a+") do ff
            write(ff, "\t$name == {ParameterType -> Internal, ComplexParameter -> False, Value -> 100, TeX -> \"$tn\"}$(i == nmax ? " " : ",")\n")
        end
        i += 1
    end
    open(file, "a+") do ff
        write(ff, "};\n")
    end
    return nothing
end





