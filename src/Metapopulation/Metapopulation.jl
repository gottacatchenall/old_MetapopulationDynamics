
module Metapopulations
    using Distributions, Distances
    using ..MetapopulationDynamics

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

 
    """
        MetapopulationGenerator
        ----------------------------------------------------
        An abstract type for functions that generate metapopulations
    """
    abstract type MetapopulationGenerator end
    
    struct PoissonProcess <: MetapopulationGenerator 
        number_of_populations::Int
        dimensions::Int
    end
    PoissonProcess(; number_of_populations = 10, dimensions = 2) = PoissonProcess(number_of_populations, dimensions)

    struct LatticeIn2D <: MetapopulationGenerator end 

 

    # -----------------------------------------------------------
    # Include methods
    # -----------------------------------------------------------
    include(joinpath(".", "constructors.jl"))
    include(joinpath(".", "distances.jl"))
 
    # export types
    export Metapopulation, Population, MetapopulationGenerator

    # export functions
    export  PoissonProcess, 
            get_lattice_metapop,
            construct_metapopulation_from_coordinates,
            get_distance_between_pops,
            get_coordinates,
            get_number_populations
end
