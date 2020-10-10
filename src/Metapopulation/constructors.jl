function (gen::PoissonProcess)()
    populations::Vector{Population} = []
    num_populations = gen.number_of_populations
    # random locations in the unit square
    for p = 1:num_populations
        coordinate = rand(Uniform(), gen.dimensions)
        push!(populations, Population(coordinate))
    end

    return(Metapopulation(populations))
end


### TODO these two functions no longer work
function LatticeIn2D(; num_populations=25, alpha::Number=5.0, kernel=ExpKernel)
    side_length::Int64 = floor(sqrt(num_populations))
    unit_distance::Float64 = (1.0/side_length)

    populations::Vector{Population} = []
    coordinates::Vector{Array{Float64}} = []

    for x = 1:side_length
        for y = 1:side_length
            coordinate = [x*unit_distance, y*unit_distance]
            push!(populations, Population(coordinate))
            push!(coordinates, coordinate)
        end
    end
    return(Metapopulation(num_populations, populations, get_dispersal_potential(coordinates, kernel, alpha)))
end

function construct_metapopulation_from_coordinates(coordinates::Array{Float64}; kernel=ExpKernel(), alpha=3.0)
    num_pops = length(coordinates[:, 1])
    dims = length(coordinates[1,:])

    if (dims > num_pops)
        print("Dimensionality of given coordinates is greater than the number of populations....\n
                Did you mean this?\n")
    end

    populations::Vector{Population} = []

    for p = 1:num_pops
        push!(populations, Population(coorindates[p,:]))
    end

    return (Metapopulation(num_pops, populations, get_dispersal_potential(coordinates, kernel, alpha)))
end
