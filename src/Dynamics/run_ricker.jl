function run_dispersal_stochastic(ibm::RickerInstance)
        num_populations = get_number_populations(ibm.metapopulation)
        old_abundance_vector = ibm.state
        new_abundance_vector::Vector{Int64} = zeros(num_populations)
        mig_prob::Float64 = ibm.parameters.migration_probability
        for p = 1:num_populations
            leaving_p_ct = 0
            for i = 1:old_abundance_vector[p]
                # choose to migrate
                
                mig_bit  = rand(Bernoulli(mig_prob))
                if mig_bit
                    leaving_p_ct += 1
                    new_pop = draw_from_dispersal_potential_row(ibm.dispersal_potential, p)
                    new_abundance_vector[new_pop] += 1
                else
                    new_abundance_vector[p] += 1
                end
            end
        end

        for p = 1:num_populations
            ibm.state[p] = new_abundance_vector[p]
        end
end

function run_dispersal_diffusion(ibm::RickerInstance)
    num_populations = get_number_populations(ibm.metapopulation)
    new_state::Array{Float64} = [ibm.state[p] for p in 1:num_populations]

    dispersal_matrix::Array{Float64} = zeros(num_populations, num_populations)

    for i = 1:num_populations
        for j = 1:num_populations
            dispersal_matrix[i,j] = ibm.parameters.migration_probability * ibm.dispersal_potential.matrix[i,j]
        end
    end
 
    for i = 1:num_populations
        for j = 1:num_populations
            val = dispersal_matrix[i,j] * ibm.state[j]
            new_state[i] += val
            new_state[j] -= val
        end
    end
    
    for p = 1:num_populations
        ibm.state[p] = Int(floor(new_state[p]))
    end

end


function run_local_dynamics(ibm::RickerInstance)
    num_populations = get_number_populations(ibm.metapopulation)
    for p = 1:num_populations
        ibm.state[p] = ibm.get_new_abundance(ibm.state[p], 
                                             mortality_probability=ibm.parameters.mortality_probability, 
                                             predation_strength=ibm.parameters.predation_strength,    
                                             base_offspring_per_indiv = ibm.parameters.base_offspring_per_indiv
                                            )
    end
end

function run_ibm_timestep(ibm::RickerInstance)
    run_local_dynamics(ibm)
    #run_dispersal_diffusion(ibm)
    run_dispersal_stochastic(ibm)
end

function run_ibm(ibm::RickerInstance)
    num_populations = get_number_populations(ibm.metapopulation)
    num_timesteps = ibm.parameters.num_timesteps 
    log_frequency = ibm.parameters.log_frequency

    abundance_log = zeros(num_populations, Int(num_timesteps/log_frequency))
    log_pt = 1
    for t = 1:num_timesteps
        run_ibm_timestep(ibm)

        if (t % log_frequency == 0)
            abundance_log[:,log_pt] = ibm.state
            log_pt += 1
        end
    end
    @show abundance_log
    return abundance_log
end


