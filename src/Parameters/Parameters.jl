module Parameters
    # -------------------------------------------------------------
    #   Libraries
    # -------------------------------------------------------------
    using ..MetapopulationDynamics
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
    
    export draw_from_parameter

end
