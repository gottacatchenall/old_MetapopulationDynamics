module Dynamics
    # -------------------------------------------------------------
    #   Libraries
    # -------------------------------------------------------------
    using ..DPE
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
    export DynamicsModel, DynamicsInstance, SimulationSettings, StochasticLogisticWDiffusion
end
