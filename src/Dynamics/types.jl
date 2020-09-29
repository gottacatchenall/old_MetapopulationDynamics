"""
    DynamicsModel
    ----------------------------------------------------
    An abstract type
"""
abstract type DynamicsModel end
struct StochasticLogisticWDiffusion <: DynamicsModel end


struct RickerModel <: DynamicsModel end
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
mutable struct DynamicsInstance{T <: DynamicsModel, W <: Number}
    model::T
    metapopulation::Metapopulation
    parameter_values::ParameterValues
    simulation_parameters::SimulationSettings
    abundance_matrix::Array{W,2}
    state::Vector{W}
end



"""
    RickerParameterBundle
    -----------------------------------------------------------
    A parameter bundle for the Ricker model. 

"""
struct RickerParameterBundle <: ParameterBundle
    lambda::Parameter 
    predation_strength::Parameter
    migration_probability::Parameter
    reproduction_probability::Parameter
end

RickerParameterBundle(;     lambda = Parameter(15),
                            predation_strength = Parameter(0.1),
                            migration_probability = Parameter(0.1),
                            reproduction_probability = Parameter(0.9) 
                           ) = RickerParameterBundle(lambda, predation_strength, migration_probability, reproduction_probability)


"""
    RickerParameterValues
    -----------------------------------------------------------
    A set of parameter values for the individual-based model (IBM).
"""

struct RickerParameterValues <: ParameterValues
    lambda::Float64
    predation_strength::Float64 
    migration_probability::Float64
    reproduction_probability::Float64
end

RickerParameterValues(; 
                   lambda::Number = 10,
                   predation_strength::Number = 0.03,
                   migration_probability::Number = 0.01,
                   reproduction_probability::Number = 0.9,
                  ) = RickerParameterValues(lambda, predation_strength, migration_probability, reproduction_probability)

RickerParameterValues(bundle::ParameterBundle) = 
            RickerParameterValues(
                lambda = draw_from_parameter(bundle.lambda),
                predation_strength = draw_from_parameter(bundle.predation_strength),
                migration_probability = draw_from_parameter(bundle.migration_probability),
                reproduction_probability = draw_from_parameter(bundle.reproduction_probability)
            )

function draw_parameter_values(bundle::RickerParameterBundle)
    return RickerParameterValues(bundle)
end



function create_dynamics_model_instance(;
                model::RickerModel = RickerModel,
                metapopulation::Metapopulation=get_random_metapopulation(), 
                parameter_values::ParameterValues=RickerParameterValues(),
                simulation_settings::SimulationSettings = SimulationSettings(),
                abundance_matrix = Array{Float64,2}(zeros(get_number_populations(metapopulation), simulation_settings.number_of_timesteps)),
                state = Vector{Float64}(rand(DiscreteUniform(10,100), get_number_populations(metapopulation))))
    DynamicsInstance(model, metapopulation, parameter_values, simulation_settings, abundance_matrix, state)
end



