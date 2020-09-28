# -----------------------------------------------------------
# Dispersal
# -----------------------------------------------------------
# declarations of types relating to dispersal, including:
#   - DispersalKernel
#   - DispersalPotential
#   -
#   -
# -----------------------------------------------------------


"""
    DispersalKernel
    -------------------------------------------Include methods----------------
        An abstract type which represents a set of parameters
        for a specific dynamics model.
"""
abstract type DispersalKernel end


"""
    DispersalPotential
    -----------------------------------------------------------
        A type which holds a matrix of floats, where matrix[i,j]
        is the probability an individual born in i reproduces in j.

        Note that this forms a probabiity distribution over j for all i,
        meaning that sum_j matrix[i,j] = 1 for all i.
"""
struct DispersalPotential
    matrix::Array{Float64}
end

# -------------------------------------------------------------
#   Treatment
# -------------------------------------------------------------


"""
    Treatment()
    ----------------------------------------------------
    A treatment contains everything that is required to
    run the simulation model:
        - a metapopulation of type ::Metapopulation
        - a model of dynamics dx_dt, of type
        - a set of priors on each parameter of type ::ParameterBundle,
          that corresponds to the model of dynamics.
            i.e. if
        - a set of simulation parameters, ::SimulationParameters
        - number of replicates
        - a vector (of length number_of_replicates) of instances of this treatment, of type ::TreatmentInstance
"""
mutable struct Treatment
    metapopulation_generator
    dx_dt::Function
    theta::ParameterBundle
    simulation_parameters::SimulationParameters
    number_of_replicates::Number
    instances::Vector{DynamicsInstance}
end
Base.show(io::IO, treatment::Treatment) = print(io, "\n\n\nTreatment w/ priors: ", treatment.theta,)


"""
    TreatmentSet()
    ----------------------------------------------------
    A TreatmentSet is a vector of Treatments, and a dataframe
    of metadata which holds information about distribution and hyperparameters
    of the parameters in the ParamaterBundle for each treatment.
"""
struct TreatmentSet
    metadata::DataFrame
    treatments::Vector{Treatment}
end
