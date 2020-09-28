
module Metapopulations
    using Distributions, Distances
    using ..DPE

    # -----------------------------------------------------------
    # Types
    # -----------------------------------------------------------

    """
        Population()
        ----------------------------------------------------
        A population, associated with a coordinate.
    """
    mutable struct Population
       coordinate::Vector{Float64}
    end

    """
        Metapopulation()
        ----------------------------------------------------
        A set of populations.
    """
    mutable struct Metapopulation
        populations::Vector{Population}
    end

   
    # -----------------------------------------------------------
    # Include methods
    # -----------------------------------------------------------
    include(joinpath(".", "constructors.jl"))
    include(joinpath(".", "distances.jl"))
 
    # export types
    export Metapopulation, Population

    # export functions
    export  get_random_metapopulation, 
            get_lattice_metapop,
            construct_metapopulation_from_coordinates,
            get_distance_between_pops,
            get_coordinates,
            get_number_populations
end
