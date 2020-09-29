module Dynamics
    # -------------------------------------------------------------
    #   Libraries
    # -------------------------------------------------------------
    using ..MetapopulationDynamics
    using Distributions

    # -----------------------------------------------------------
    # Include methods
    # -----------------------------------------------------------
    include(joinpath("types.jl"))
    include(joinpath("ricker_model.jl"))
    include(joinpath("run_ricker.jl"))
    include(joinpath(".", "StochasticLogisticWDiffusion.jl"))

    # -----------------------------------------------------------
    # export
    # -----------------------------------------------------------
    export  DynamicsModel, 
            DynamicsInstance, 
            SimulationSettings, 
            StochasticLogisticWDiffusion,
            RickerModel,
            RickerParameterBundle
end
