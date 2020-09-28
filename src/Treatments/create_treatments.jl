# =================================================
#    treatment maker
#
#
# =================================================
function get_dist(item)
	if typeof(item) <: Distribution
		return item
	else
		return Normal(item, 0.0)
	end
end


function create_treatments(param_dict::Dict; replicates_per_treatment::Int64 = 50)
	metadata::DataFrame = create_metadata_df(param_dict)
	n_treatments::Int64 = nrow(metadata)

	treatments::Vector{Treatment} = []

	for t = 1:n_treatments
		num_pops = metadata.num_populations[t]
		alpha = metadata.alpha[t]

		migration_rate_distribution::Distribution = get_dist(metadata.migration_rate[t])
		lambda_distribution::Distribution = get_dist(metadata.lambda[t])
		sigma_distribution::Distribution = get_dist(metadata.sigma[t])
		carrying_capacity_distribution::Distribution = get_dist(metadata.carrying_capacity[t])

        dimensionality::Int64 = num_pops

		alpha_dist = Parameter(Normal(alpha, 0.0), 1)
		m_dist = Parameter(migration_rate_distribution, dimensionality)
		lambda_dist = Parameter(lambda_distribution, dimensionality)
		sigma_dist = Parameter(sigma_distribution, dimensionality)
		carrying_cap_dist = Parameter(carrying_capacity_distribution, dimensionality)

		param_bundle = StochasticLogisticParameterBundle(num_pops, alpha, m_dist, lambda_dist, sigma_dist, carrying_cap_dist)

		dynamics_model = StochasticLogisticWDiffusion()
		sim_params = SimulationParameters(metadata.number_of_timesteps[t], 0.1, 10, false)

		mp = metadata.metapopulation_generator[t](num_populations=num_pops, alpha=alpha)

        tr = Treatment(mp, dynamics_model, sim_params, param_bundle, metadata.summary_stat[t], metadata.log_abundances[t],metadata.log_metapopulations[t] , [])
		push!(treatments, tr)
	end

	return TreatmentSet(metadata, treatments, replicates_per_treatment )
end
