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


function create_treatment(model::T, id::Int, metadata::DataFrameRow) where {T <: RickerModel}

	mp = metadata.fixed_metapopulation
	if (mp == false)
        mp = PoissonProcess(number_of_populations=metadata.number_of_populations)
	end


	dispersal_potential = IBDandCutoff(
        alpha = Parameter(metadata.alpha),
        epsilon= Parameter(metadata.epsilon),
        kernel=metadata.dispersal_kernel()
	)

	param_bundle = RickerParameterBundle(
		lambda = Parameter(metadata.lambda),
		migration_probability = Parameter(metadata.migration_probability),
		predation_strength = Parameter(metadata.predation_strength),
		reproduction_probability = Parameter(metadata.reproduction_probability)
	)

	simulation_settings = SimulationSettings()
	return Treatment(	
                id = id,
                metapopulation = mp,
				dispersal_potential = dispersal_potential,
				model = model,
				theta = param_bundle,
				number_of_replicates = metadata.number_of_replicates
				)
end

function create_treatments_from_param_dictionary(param_dict::Dict; summary_stat::Union{T, Vector{T}} = PCC(), replicates_per_treatment::Int64 = 50) where T <: SummaryStat
	metadata::DataFrame = create_metadata_df(param_dict)
	n_treatments::Int64 = nrow(metadata)

	treatments::Vector{Treatment} = []

	for t = 1:n_treatments
		model = metadata.model[t]
		tr = create_treatment(model, t, metadata[t,:])
		push!(treatments, tr)
	end

	return TreatmentSet(metadata, treatments, summary_stat, DataFrame(treatment=[], replicate=[], summary_stat=[]))
end
