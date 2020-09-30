
function ricker_demographic_stochasticity(old_abundance; lambda::Float64 = 5.0, reproduction_probability::Float64 = 0.9, predation_strength::Float64 = 0.1)
    poisson_rate = old_abundance * lambda* (reproduction_probability) * exp(-1*predation_strength*old_abundance)
    return rand(Poisson(poisson_rate))
end

function run_dispersal_stochastic(inst::DynamicsInstance)
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

function run_dispersal_diffusion(inst::DynamicsInstance)
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


function run_local_dynamics(inst::DynamicsInstance)
    num_populations = get_number_populations(inst.metapopulation)
    for p = 1:num_populations
        inst.state[p] = ricker_demographic_stochasticity(inst.state[p],
                                             reproduction_probability=inst.parameters.reproduction_probability,
                                             predation_strength=inst.parameters.predation_strength,
                                             lambda = inst.parameters.lambda
                                            )
    end
end


function RickerModel(inst::DynamicsInstance; dispersal_function::Function = run_dispersal_stochastic)
    num_populations = get_number_populations(inst.metapopulation)
    num_timesteps = inst.settings.number_of_timesteps
    log_frequency = inst.settings.log_frequency

    log_pt = 1
    for t = 1:num_timesteps
        run_local_dynamics(inst)
        dispersal_function(inst)
        inst.abundance_matrix[:,t] = inst.state
        log_pt += 1
    end
end

function RickerModelWStochasticDispersal(inst::DynamicsInstance)
    RickerModel(inst, dispersal_function=run_dispersal_stochastic)
end

function RickerModelWDiffusionDispersal(inst::DynamicsInstance)
    RickerModel(inst, dispersal_function=run_dispersal_diffusion)
end
