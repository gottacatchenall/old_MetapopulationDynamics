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
    dimensionality::Int64
    Parameter(distribution::Distribution; dimensionality=1) = new(distribution, dimensionality)
    Parameter(value::Number; dimensionality = 1) = new(Normal(value, 0.0), dimensionality)
end
Base.show(io::IO, p::Parameter) = print(io, "Parameter ~ ", p.distribution, "\n")

function draw_from_parameter(param::Parameter)
    vals = rand(param.distribution, param.dimensionality)
    if (param.dimensionality == 1)
        return vals[1]
    else
        return vals
    end
end


