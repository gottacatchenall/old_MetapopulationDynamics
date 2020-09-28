function get_distance_between_pops(coord1::Array{Float64,1}, coord2::Array{Float64,1}; norm=Euclidean())
    distance::Float64 = evaluate(norm, coord1, coord2)
    return distance
end

function get_distance_between_pops(pop1::Population, pop2::Population; norm=Euclidean())
    distance::Float64 = evaluate(norm, pop1.coordinate, pop2.coordinate)
    return(distance)
end

function get_coordinates(mp::Metapopulation)
    return [mp.populations[p].coordinate for p = 1:mp.num_populations]
end

function get_number_populations(mp::Metapopulation)
    return length(mp.populations)
end
