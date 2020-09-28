module Dispersal
    using ..DPE
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
            is the probability an individual born in i reproduces in j.
            
            Note that this forms a probabiity distribution over j for all i, 
            meaning that sum_j matrix[i,j] = 1 for all i. 
    """
    struct DispersalPotential
        matrix::Array{Float64}
    end


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
            GaussKernel, 
            ExpKernel

    export get_dispersal_potential, draw_from_dispersal_potential_row
end
