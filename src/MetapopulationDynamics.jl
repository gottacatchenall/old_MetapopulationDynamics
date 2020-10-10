# MetapopulationDynamics.jl
module MetapopulationDynamics

    # Other libraries
    using Random
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
        # Parameters
        # -----------------------------------------------------------
        include(joinpath(".", "Parameters/Parameters.jl"))
        using .Parameters
        export  Parameter,
                ParameterBundle,
                ParameterValues

        export draw_from_parameter 

        # -----------------------------------------------------------
        # Metapopulation
        # -----------------------------------------------------------
        include(joinpath(".", "Metapopulation/Metapopulation.jl"))
        using .Metapopulations
        export Metapopulation, Population, MetapopulationGenerator
        export  PoissonProcess,
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
        export DispersalPotential, DispersalPotentialGenerator, ExpKernel, GaussKernel
        export IBDandCutoff, draw_from_dispersal_potential_row


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
        export draw_parameter_values, run_dynamics_simulation, create_dynamics_model_instance


        # -----------------------------------------------------------
        # SummaryStats
        # -----------------------------------------------------------
        include(joinpath(".", "SummaryStats/SummaryStats.jl"))
        using .SummaryStats
        export SummaryStat, PCC, MeanAbundance

        # -----------------------------------------------------------
        # Treatments
        # -----------------------------------------------------------
        include(joinpath(".", "Treatments/Treatments.jl"))
        using .Treatments
        export  Treatment,
                TreatmentSet
        export run_treatment, run_treatments, create_treatments_from_param_dictionary

        # -----------------------------------------------------------
        # ABCSampler
        # -----------------------------------------------------------
        include(joinpath(".", "ABCSampler/ABCSampler.jl"))

end
