function run_dispersal_stochastic(inst::RickerInstance)
        num_populations = get_number_populations(inst.metapopulation)
        old_abundance_vector = inst.state
        new_abundance_vector::Vector{Int64} = zeros(num_populations)
        mig_prob::Float64 = inst.parameters.migration_probability
        for p = 1:num_populations
            leaving_p_ct = 0
            for i = 1:old_abundance_vector[p]
                # choose to migrate
                
                mig_bit  = rand(Bernoulli(mig_prob))
                if mig_bit
                    leaving_p_ct += 1
                    new_pop = draw_from_dispersal_potential_row(inst.dispersal_potential, p)
                    new_abundance_vector[new_pop] += 1
                else
                    new_abundance_vector[p] += 1
                end
            end
        end

        for p = 1:num_populations
            inst.state[p] = new_abundance_vector[p]
        end
end

function run_dispersal_diffusion(inst::RickerInstance)
    num_populations = get_number_populations(inst.metapopulation)
    new_state::Array{Float64} = [inst.state[p] for p in 1:num_populations]

    dispersal_matrix::Array{Float64} = zeros(num_populations, num_populations)

    for i = 1:num_populations
        for j = 1:num_populations
            dispersal_matrix[i,j] = inst.parameters.migration_probability * inst.dispersal_potential.matrix[i,j]
        end
    end
 
    for i = 1:num_populations
        for j = 1:num_populations
            val = dispersal_matrix[i,j] * inst.state[j]
            new_state[i] += val
            new_state[j] -= val
        end
    end
    
    for p = 1:num_populations
        inst.state[p] = Int(floor(new_state[p]))
    end

end


function run_local_dynamics(inst::RickerInstance)
    num_populations = get_number_populations(inst.metapopulation)
    for p = 1:num_populations
        inst.state[p] = inst.get_new_abundance(inst.state[p], 
                                             mortality_probability=inst.parameters.mortality_probability, 
                                             predation_strength=inst.parameters.predation_strength,    
                                             base_offspring_per_indiv = inst.parameters.base_offspring_per_indiv
                                            )
    end
end

function run_ricker_timestep(inst::RickerInstance)
    run_local_dynamics(inst)
    #run_dispersal_diffusion(inst)
    run_dispersal_stochastic(inst)
end

function RickerModel(inst::RickerInstance)
    num_populations = get_number_populations(inst.metapopulation)
    num_timesteps = inst.parameters.num_timesteps 
    log_frequency = inst.parameters.log_frequency

    abundance_log = zeros(num_populations, Int(num_timesteps/log_frequency))
    log_pt = 1
    for t = 1:num_timesteps
        run_ricker_timestep(inst)

        if (t % log_frequency == 0)
            abundance_log[:,log_pt] = inst.state
            log_pt += 1
        end
    end
    @show abundance_log
    return abundance_log
end

