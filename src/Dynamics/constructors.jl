

function create_dynamics_model_instance(;
                model::DynamicsModel = RickerModelWStochasticDispersal,
                metapopulation::Metapopulation=get_random_metapopulation(),
                dispersal_potential::DispersalPotential=get_dispersal_potential(metapopulation),
                parameter_values::ParameterValues=RickerParameterValues(),
                simulation_settings::SimulationSettings = SimulationSettings(),
                abundance_matrix = Array{Float64,2}(zeros(get_number_populations(metapopulation), simulation_settings.number_of_timesteps)),
                state = Vector{Float64}(rand(DiscreteUniform(10,100), get_number_populations(metapopulation))))
    DynamicsInstance(model, metapopulation, dispersal_potential, parameter_values, simulation_settings, abundance_matrix, state)
end

function draw_parameter_values(bundle::RickerParameterBundle)
    return RickerParameterValues(bundle)
end
