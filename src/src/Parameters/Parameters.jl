module Parameters
    # -------------------------------------------------------------
    #   Libraries
    # -------------------------------------------------------------
    using ..DPE: Metapopulations, Dispersal
    using Distributions


    # -----------------------------------------------------------
    # Include methods
    # -----------------------------------------------------------
    include(joinpath(".", "types.jl"))

    # -----------------------------------------------------------
    # export
    # -----------------------------------------------------------

    # types
    export  Parameter,
            ParameterBundle,
            ParameterValues


end
