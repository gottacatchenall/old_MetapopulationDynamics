
function check_for_nondefaults(param_dict::Dict)

    # Flag to not generate a random metapopulation every replicate
        # use-cases:
        #   - user defined metapopulation provided as CSV
        #   - only generate a new metapopulation at the Treatment or higher level

    # Flag to use a defined random seed
    #
    #

    # Flag to use stochastic dispersal, where dispersal events
    # occur according random draws from a Binomial(abundance, migration_probability).
    #

    # Flag to use

end

function create_metadata_df(param_dict::Dict)
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
