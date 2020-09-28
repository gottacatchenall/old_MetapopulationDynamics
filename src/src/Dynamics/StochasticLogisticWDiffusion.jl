function stochastic_logistic_single_population(abundance::Float64, sigma::Float64, lambda::Float64, dt::Float64, dW::Float64, carrying_capacity::Float64)::Float64
    if (abundance > 0)
        delta_abundance_deterministic::Float64 =  abundance*lambda*(1.0-(abundance/carrying_capacity))
        delta_abundance_stochastic::Float64 = rand(Normal(0, abs(sigma*abundance)))

        new_abundance::Float64 = abundance + delta_abundance_deterministic*dt + delta_abundance_stochastic*dW
        return new_abundance
    else
        return 0.0
    end
end

struct StochasticLogisticParameterValues <: ParameterValues
    lambda::Float64
    migration_probability::Float64
    sigma::Float64
end

StochasticLogisticParameterValues(; lambda::Number = 2.0, 
                                    migration_probability::Number=0.1, 
                                    sigma::Number = 0.5
                                   ) = StochasticLogisticParameterValues(lambda, migration_probability, sigma)


StochasticLogisticWDiffusion() =
    function(treatment_instance::DynamicsInstance)
    simulation_parameters = treatment_instance.simulation_parameters
    parameter_values::StochasticLogisticParameterValues = treatment_instance.parameter_values
    num_populations = treatment_instance.metapopulation.num_populations

    sigma::Vector{Float64} = parameter_values.sigma
    lambda::Vector{Float64} = parameter_values.lambda
    carrying_capacity::Vector{Float64} = parameter_values.carrying_capacity

    dt::Float64 = simulation_parameters.timestep_width
    dW::Float64 = simulation_parameters.timestep_width

    current_state::Array{Float64} = treatment_instance.state
    new_state::Array{Float64} = zeros(num_populations)

    # stochastic logistic model locally
    for p = 1:num_populations
        new_state[p] = stochastic_logistic_single_population(current_state[p], sigma[p], lambda[p], dt, dW, carrying_capacity[p])
    end

    # diffusion between populations
    dispersal_potential = treatment_instance.metapopulation.dispersal_potential
    diffusion_matrix = get_dispersal_matrix(dispersal_potential, parameter_values.migration_rate)
    new_state = diffusion_matrix * new_state

    treatment_instance.state = new_state
end


function get_dispersal_matrix(dispersal_potential::DispersalPotential, migration_rate::Vector{Float64})
    n_pops = length(dispersal_potential.matrix[1,:])
    migration_max = 1.0 - (1.0/n_pops)

    dispersal_matrix = zeros(n_pops, n_pops)
    for p1 = 1:n_pops
        for p2 = 1:n_pops
            if (p1 == p2)
                dispersal_matrix[p1,p2] = 1.0 -  migration_rate[p1]
            else
                dispersal_matrix[p1,p2] =  migration_rate[p1]* dispersal_potential.matrix[p1,p2]
            end
        end
    end

    return dispersal_matrix
end
