"""
    ParameterBundle
    -----------------------------------------------------------
        An abstract type which represents a set of parameters
        for a specific dynamics model.

        Each concrete instance of a ParameterBundle contains a
        set of named Parameters in an parametric type.
            e.g. StochasticLogisticParameterBundle contains fields of
                 type Parameter which correspond to sigma, lambda, etc.
"""
abstract type ParameterBundle end


"""
    ParameterValues
    ----------------------------------------------------
    An abstract type which represents a the values of parameters
    for a specific dynamics model.

    Each concrete instance of ParameterValues contains the values of
    each named parameter in a parametric type.
        e.g. StochasticLogisticParameterValues contains fields of type
             <: Number for sigma, lambda, etc.
"""
abstract type ParameterValues end

"""
    Parameter()
    ----------------------------------------------------
    Each parameter has a distribution with provided hyperparameters.

"""
struct Parameter
    distribution::Distribution
    hyperparameters::Vector{Parameter}
    dimensionality::Int64
    Parameter(distribution::Distribution, dimensionality::Int64; hyperparameters=[])  = new(distribution, hyperparameters, dimensionality)
    Parameter(distribution::Distribution; dimensionality=1) = new(distribution, [], dimensionality)
end
Base.show(io::IO, p::Parameter) = print(io, "Parameter ~ ", p.distribution, "\n")



"""
    StochasticLogisticParameterBundle()
    ----------------------------------------------------
    The bundle of parameters for the stochastic
    logistic Model
"""
struct StochasticLogisticParameterBundle <: ParameterBundle
    num_populations::Int64
    alpha::Float64
    migration_rate::Parameter
    lambda::Parameter
    sigma::Parameter
    carrying_capacity::Parameter
end

"""
    StochasticLogisticParameterValues()
    ----------------------------------------------------
    The value of parameters for an instance of the
    stochastic logistic model.
"""
struct StochasticLogisticParameterValues <: ParameterValues
    num_populations::Int64
    alpha::Float64  # dispersal kernel alpha
    lambda::Vector{Float64} # lambda across pops
    migration_rate::Vector{Float64} # mig across pops
    carrying_capacity::Vector{Float64} # K across pops
    sigma::Vector{Float64} # sigma across pops
end
