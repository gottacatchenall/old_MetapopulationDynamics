"""
   ABC Sampler


Takes in inputs:  abundance data, priors, tolerance (rho)
    Compute summary-stat, CC-matrix

    For r in number of replicates
        1. Sample a theta (of type ::ParameterValues) from the priors (type ::ParameterBundle)
        2. Get a CC-matrix
        3. Compute distance of real CC-matrix from this CC-matrix
        4. Accept into chain if  dist < rho



ABC Params
    1. Rho
    2. Burn-in(?) length
    3. Thinning amount
    4. Number of steps
"""

function run_abc_sampler(abundance_matrix)
end
