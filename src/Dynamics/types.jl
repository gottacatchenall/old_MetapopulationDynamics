"""
    DynamicsModel
    ----------------------------------------------------
    An abstract type
"""
abstract type DynamicsModel end
struct StochasticLogisticWDiffusion <: DynamicsModel end

"""
    SimulationSettings()
    ----------------------------------------------------
    A parametric struct which contains parameters related
    to simulating dynamics.
"""
mutable struct SimulationSettings
    number_of_timesteps::Int64
    timestep_width::Float64
    log_frequency::Int64
    log_abundances::Bool
    log_metapopulation::Bool
end
SimulationSettings(; number_of_timesteps = 100, timestep_width=0.1, log_frequency=10, log_abundances=false, log_metapopulation=false) = 
    SimulationSettings(number_of_timesteps, timestep_width, log_frequency, log_abundances, log_metapopulation)

"""
    DynamicsInstance()
    ----------------------------------------------------
    An instance of a treatment, which contains the resulting
    abundance matrix.
"""
mutable struct DynamicsInstance{T}
    metapopulation::Metapopulation
    dx_dt::T
    simulation_parameters::SimulationSettings
    parameter_values::ParameterValues
    abundance_matrix::Array{Float64,2}
    state::Array{Float64}
end

DynamicsInstance(;  metapopulation = get_random_metapopulation(),
                    dx_dt = StochasticLogisticWDiffusion,
                    simulation_settings=SimulationSettings(),
                    parameter_values = StochasticLogisticParameterValues(),
                    abundance_matrix = zeros(get_number_populations(metapopulation), simulation_settings.number_of_timesteps),
                    state = zeros(get_number_populations(metapopulation), simulation_settings.number_of_timesteps)
                   ) = DynamicsInstance(metapopulation, dx_dt, simulation_settings, parameter_values, abundance_matrix, rand(Uniform(), get_number_populations(metapopulation)))

"""
    RickerParameterValues
    -----------------------------------------------------------
    A set of parameter values for the individual-based model (IBM).
"""

struct RickerParameterValues <: ParameterValues
    mortality_probability::Float64
    predation_strength::Float64 
    migration_probability::Float64
    base_offspring_per_indiv::Float64
    num_timesteps::Int64
    log_frequency::Int64
end

RickerParameterValues(; 
                   mortality_probability::Number = 0.1,
                   predation_strength::Number = 0.03,
                   migration_probability::Number = 0.01,
                   base_offspring_per_indiv::Number = 3,
                   num_timesteps::Number = 1000,
                   log_frequency::Number = 10
                  ) = RickerParameterValues(mortality_probability, predation_strength, migration_probability, base_offspring_per_indiv, num_timesteps, log_frequency)

"""
    IBMInstance
    -----------------------------------------------------------
    An instance of the IBM 
"""
struct RickerInstance 
    metapopulation::Metapopulation
    parameters::RickerParameterValues
    dispersal_potential::DispersalPotential
    get_new_abundance::Function
    state::Vector{Int}
end

RickerInstance(;
            metapopulation=get_random_metapopulation(), 
            parameters = RickerParameterValues(),
            get_new_abundance = ricker_demographic_stochasticity,
            state = []
           ) =  RickerInstance(metapopulation, 
                            parameters, 
                            get_dispersal_potential(metapopulation), 
                            get_new_abundance, 
                            rand(DiscreteUniform(10, 100), get_number_populations(metapopulation)))
