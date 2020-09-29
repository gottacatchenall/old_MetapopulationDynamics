
# -------------------------------------------------------------
#   Types
# -------------------------------------------------------------
"""
    Treatment()
    ----------------------------------------------------
    A treatment contains everything that is required to
    run the simulation model:
        - a metapopulation of type ::Metapopulation
        - a model of dynamics dx_dt, of type
        - a set of priors on each parameter of type ::ParameterBundle,
          that corresponds to the model of dynamics.
        - a set of simulation parameters, ::SimulationParameters
        - number of replicates
        - a vector (of length number_of_replicates) of instances of this treatment, of type ::TreatmentInstance
"""
mutable struct Treatment{T <: DynamicsModel, W <: ParameterBundle}
    metapopulation::Metapopulation
    model::T
    theta::W
    simulation_settings::SimulationSettings
    number_of_replicates::Int
    instances
end
Base.show(io::IO, treatment::Treatment) = print(io, "\n\n\nTreatment:  \n", "Priors: \t", treatment.theta, "\nInstances: ", instances)


Treatment(
          ;     metapopulation = get_random_metapopulation(),
                instance_maker = RickerModel(),
                theta = RickerParameterBundle(),
                simulation_settings = SimulationSettings(),
                number_of_replicates = 50,
                instances = []
               ) = Treatment(metapopulation, instance_maker, theta, simulation_settings, number_of_replicates, instances)



"""
    TreatmentSet()
    ----------------------------------------------------
    A TreatmentSet is a vector of Treatments, and a dataframe
    of metadata which holds information about distribution and hyperparameters
    of the parameters in the ParamaterBundle for each treatment.
"""
struct TreatmentSet
    metadata::DataFrame
    treatments::Vector{Treatment}
end
