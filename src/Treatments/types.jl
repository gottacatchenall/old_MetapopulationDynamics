
# -------------------------------------------------------------
#   Types
# -------------------------------------------------------------
"""
    Treatment()
    ----------------------------------------------------
    A treatment contains everything that is required to
    run the simulation model:
        - Either 
            - a metapopulation of type ::Metapopulation 
        - a me
        - a model of dynamics dx_dt, of type
        - a set of priors on each parameter of type ::ParameterBundle,
          that corresponds to the model of dynamics.
        - a set of simulation parameters, ::SimulationParameters
        - number of replicates
        - a vector (of length number_of_replicates) of instances of this treatment, of type ::TreatmentInstance
"""
mutable struct Treatment{T <: DynamicsModel, W <: ParameterBundle}
    id::Int
    metapopulation::Union{Metapopulation, MetapopulationGenerator}
    dispersal_potential::Union{DispersalPotential, DispersalPotentialGenerator}
    model::T
    theta::W
    simulation_settings::SimulationSettings
    number_of_replicates::Int
    instances
end
Base.show(io::IO, treatment::Treatment) = print(io, "\n\n\nTreatment:  \n", "Priors: \t", treatment.theta, "\nInstances: ", instances)


Treatment(
          ;     metapopulation = PoissonProcess(),
                dispersal_potential = IBDandCutoff(),
                model = RickerModelWStochasticDispersal(),
                theta = RickerParameterBundle(),
                simulation_settings = SimulationSettings(),
                number_of_replicates = 50,
                instances = [],
                id = 1
               ) = Treatment(id, metapopulation, dispersal_potential, model, theta, simulation_settings, number_of_replicates, instances)



"""
    TreatmentSet()
    ----------------------------------------------------
    A TreatmentSet is a vector of Treatments, and a dataframe
    of metadata which holds information about distribution and hyperparameters
    of the parameters in the ParamaterBundle for each treatment.
"""
mutable struct TreatmentSet{T <: Union{SummaryStat, Vector{SummaryStat}}}
    metadata::DataFrame  # a dataframe of treatment, replicate, param values
    treatments::Vector{Treatment}
    summary_stat::T
    output::DataFrame    # a dataframe of treatment, replicate, summary_stat
end
