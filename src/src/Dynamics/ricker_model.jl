function ricker_demographic_stochasticity(old_abundance; mortality_probability = 0.1, predation_strength = 0.05, base_offspring_per_indiv = 3.0)
    poisson_rate = old_abundance * base_offspring_per_indiv* (1.0 - mortality_probability) * exp(-1*predation_strength*old_abundance)
    return rand(Poisson(poisson_rate))
end
