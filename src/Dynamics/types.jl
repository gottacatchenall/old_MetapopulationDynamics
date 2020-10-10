"""
    DynamicsModel
    ----------------------------------------------------
    An abstract type
"""
abstract type DynamicsModel end

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
mutable struct DynamicsInstance{T <: DynamicsModel}
    model::T
    metapopulation::Metapopulation
    dispersal_potential::DispersalPotential
    parameters::ParameterValues
    settings::SimulationSettings
    abundance_matrix::Array{Float64,2}
    state::Vector{Float64}
end
