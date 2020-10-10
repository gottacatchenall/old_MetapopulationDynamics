module Dispersal
    using ..MetapopulationDynamics
    using Distributions
    # -----------------------------------------------------------
    # Types
    # -----------------------------------------------------------

    """
        DispersalKernel 
        -----------------------------------------------------------
            An abstract type which represents a set of parameters
            for a specific dynamics model. 
    """
    abstract type DispersalKernel end


    """
        DispersalPotential 
        -----------------------------------------------------------
            A type which holds a matrix of floats, where matrix[i,j]
            is the probability an individual born in i reproduces in j, 
            given that individual migrates during its lifetime.
            
            Note that this forms a probabiity distribution over j for all i, 
            meaning that sum_j matrix[i,j] = 1 for all i. 
    """
    struct DispersalPotential
        matrix::Array{Float64}
    end

    """
        DispersalPotentialGenerator 
        -----------------------------------------------------------
            An abstract type for an object that generates a dispersal potentital according
            to a set of parameters.
    """
    abstract type DispersalPotentialGenerator end
    struct IBDandCutoff{T <: DispersalKernel} <: DispersalPotentialGenerator 
        alpha::Parameter
        epsilon::Parameter
        kernel::T
    end
    IBDandCutoff(; alpha=Parameter(3.0), epsilon=Parameter(0.1), kernel=ExpKernel()) = IBDandCutoff(alpha, epsilon, kernel)


    # -----------------------------------------------------------
    # Include methods
    # -----------------------------------------------------------
    include(joinpath(".", "kernels.jl"))
    include(joinpath(".", "dispersal_potential.jl"))

    # -----------------------------------------------------------
    # Export types and functions
    # -----------------------------------------------------------
    export  DispersalPotential, 
            DispersalKernel, 
            DispersalPotentialGenerator,
            IBDandCutoff,
            GaussKernel, 
            ExpKernel

    export get_dispersal_potential, draw_from_dispersal_potential_row
end
