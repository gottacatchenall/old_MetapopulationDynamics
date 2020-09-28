
# =================================================
#    treatment runner
#
#
# =================================================

function run_treatments(treatment_set::TreatmentSet; abundances_path = "./abundances.csv", metapopulations_path = "./metapopulations.csv")
	n_treatments::Int64 = length(treatment_set.treatments)
	n_replicates::Int64 = treatment_set.replicates_per_treatment

	treatments::Vector{Treatment} = treatment_set.treatments
	@show treatments
	df = DataFrame()

	@showprogress for t in (1:n_treatments)
		summary_stat::Function = treatments[t].summary_stat
		for r = 1:n_replicates
			param_values = draw_from_parameter_bundle(treatments[t].theta)

			mp = treatments[t].metapopulation_generator
			abundance_matrix = zeros(Int64(ceil(treatments[t].simulation_parameters.number_of_timesteps/treatments[t].simulation_parameters.log_frequency)), mp.num_populations)
			initial_condition = [rand(Uniform(0, param_values.carrying_capacity[p])) for p = 1:mp.num_populations]

			treatment_instance::TreatmentInstance = TreatmentInstance(mp, treatments[t].dx_dt, treatments[t].simulation_parameters, param_values, abundance_matrix, initial_condition)
			push!(treatments[t].instances, treatment_instance)

			treatment_instance.abundance_matrix = run_dynamics(treatment_instance)

			stat_df = summary_stat(treatment_instance, t, r)
			df = vcat(df, stat_df)

			if (treatments[t].log_abundances)
				log_abundances(t, r, treatment_instance, filename=abundances_path)
			end

            if (treatments[t].log_metapopulation)
                log_metapopulation(t,r,treatment_instance, filename=metapopulations_path)
            end

		end
	end

	return df
end
