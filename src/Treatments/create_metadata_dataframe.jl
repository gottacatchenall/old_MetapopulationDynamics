
function check_for_nondefaults(param_dict::Dict)

	if haskey(param_dict, "number_of_replicates") == false
		param_dict["number_of_replicates"] = [50]
	end

	if (haskey(param_dict, "fixed_metapopulation")) == false
		param_dict["fixed_metapopulation"] = [false]
	end

	if (haskey(param_dict, "number_of_populations")) == false
		param_dict["number_of_populations"] = [10]
	end

	if haskey(param_dict, "model") == false
		param_dict["model"] = [RickerModelWStochasticDispersal]
	end

	if haskey(param_dict, "dispersal_kernel") == false
		param_dict["dispersal_kernel"] = [ExpKernel]
	end

	if haskey(param_dict, "alpha") == false
		param_dict["alpha"] = [3.0]
	end

	if haskey(param_dict, "epsilon") == false
		param_dict["epsilon"] = [0.01]
	end

	if haskey(param_dict, "lambda") == false
		param_dict["lambda"] = [15.0]
	end

	if haskey(param_dict, "migration_probability") == false
		param_dict["migration_probability"] = [0.3]
	end

	if haskey(param_dict, "reproduction_probability") == false
		param_dict["reproduction_probability"] = [0.9]
	end

	if haskey(param_dict, "predation_strength") == false
		param_dict["predation_strength"] = [0.03]
	end

	if haskey(param_dict, "random_seed") == false
		param_dict["random_seed"] = [rand(DiscreteUniform(0, 10^10))]
	end

	@show param_dict
end

function create_metadata_df(param_dict::Dict)
	check_for_nondefaults(param_dict)

	names::Array{String} = []
	vals = []
	metadata = DataFrame(names...)
	metadata.treatment = []

	for (param_name, param_values) in param_dict
		push!(names, param_name)
		push!(vals, param_values)
		metadata[!,  Symbol(param_name)] = []
	end
	ct = 1
	for p in Iterators.product(vals...)
		for (i, val) in enumerate(p)
			param = names[i]
			push!(metadata[!, Symbol(param)], val)
		end
		push!(metadata.treatment, ct)
		ct += 1
	end
	return(metadata)
end
