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
    include(joinpath("RickerModel", "ricker_model_types.jl"))
    include(joinpath("RickerModel", "ricker_model_dynamics.jl"))
    include(joinpath(".", "constructors.jl"))
    include(joinpath(".", "run_dynamics.jl"))
    include(joinpath("StochasticLogistic", "StochasticLogisticWDiffusion.jl"))

    # -----------------------------------------------------------
    # export
    # -----------------------------------------------------------
    export  DynamicsModel,
            DynamicsInstance,
            SimulationSettings,
            RickerModel,
            RickerModelWDiffusionDispersal,
            RickerModelWStochasticDispersal,
            RickerParameterBundle,
            RickerParameterValues

    export create_dynamics_model_instance, draw_parameter_values, run_dynamics_simulation
end
