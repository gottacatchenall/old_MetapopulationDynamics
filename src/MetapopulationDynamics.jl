# MetapopulationDynamics.jl
module MetapopulationDynamics

    # Other libraries
    using StatsBase
    using Distributions
    using DataFrames
    using CSV
    using ProgressMeter
    using LinearAlgebra


    # -----------------------------------------------------------
    # Submodules
    # -----------------------------------------------------------

        # -----------------------------------------------------------
        # Metapopulation
        # -----------------------------------------------------------
        include(joinpath(".", "Metapopulation/Metapopulation.jl"))
        using .Metapopulations
        export Metapopulation, Population
        export  get_random_metapopulation,
                get_lattice_metapop,
                construct_metapopulation_from_coordinates,
                get_distance_between_pops,
                get_coordinates,
                get_number_populations

        # -----------------------------------------------------------
        # Dispersal
        # -----------------------------------------------------------
        include(joinpath(".", "Dispersal/Dispersal.jl"))
        using .Dispersal
        export DispersalPotential, ExpKernel, GaussKernel
        export get_dispersal_potential, draw_from_dispersal_potential_row

        # -----------------------------------------------------------
        # Parameters
        # -----------------------------------------------------------
        include(joinpath(".", "Parameters/Parameters.jl"))
        using .Parameters
        export  Parameter,
                ParameterBundle,
                ParameterValues

        export draw_from_parameter, create_dynamics_model_instance

        # -----------------------------------------------------------
        # Dynamics
        # -----------------------------------------------------------
        include(joinpath(".", "Dynamics/Dynamics.jl"))
        using .Dynamics
        export  DynamicsModel,
                DynamicsInstance,
                SimulationSettings,
                RickerModel,
                RickerModelWDiffusionDispersal,
                RickerModelWStochasticDispersal,
                RickerParameterBundle,
                RickerParameterValues
        export draw_parameter_values, run_dynamics_simulation
        # -----------------------------------------------------------
        # Treatments
        # -----------------------------------------------------------
        include(joinpath(".", "Treatments/Treatments.jl"))
        using .Treatments
        export  Treatment,
                TreatmentSet
        export draw_instance_from_treatment
        # -----------------------------------------------------------
        # SumamryStats
        # -----------------------------------------------------------
        include(joinpath(".", "SummaryStats/SummaryStats.jl"))
        using .SummaryStats
        export SummaryStat, PCC


        # -----------------------------------------------------------
        # ABCSampler
        # -----------------------------------------------------------
        include(joinpath(".", "ABCSampler/ABCSampler.jl"))

end
