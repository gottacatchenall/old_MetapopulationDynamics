

abstract type RickerModel <: DynamicsModel end
struct RickerModelWStochasticDispersal <: RickerModel end
struct RickerModelWDiffusionDispersal <: RickerModel end



"""
    RickerParameterBundle
    -----------------------------------------------------------
    A parameter bundle for the Ricker model.

"""
struct RickerParameterBundle <: ParameterBundle
    lambda::Parameter
    predation_strength::Parameter
    migration_probability::Parameter
    reproduction_probability::Parameter
end

RickerParameterBundle(;     lambda = Parameter(15),
                            predation_strength = Parameter(0.03),
                            migration_probability = Parameter(0.3),
                            reproduction_probability = Parameter(0.9)
                           ) = RickerParameterBundle(lambda, predation_strength, migration_probability, reproduction_probability)


"""
    RickerParameterValues
    -----------------------------------------------------------
    A set of parameter values for the individual-based model (IBM).
"""

struct RickerParameterValues <: ParameterValues
    lambda::Float64
    predation_strength::Float64
    migration_probability::Float64
    reproduction_probability::Float64
end

RickerParameterValues(;
                   lambda::Number = 10,
                   predation_strength::Number = 0.03,
                   migration_probability::Number = 0.01,
                   reproduction_probability::Number = 0.9,
                  ) = RickerParameterValues(lambda, predation_strength, migration_probability, reproduction_probability)
RickerParameterValues(bundle::ParameterBundle) =
            RickerParameterValues(
                lambda = draw_from_parameter(bundle.lambda),
                predation_strength = draw_from_parameter(bundle.predation_strength),
                migration_probability = draw_from_parameter(bundle.migration_probability),
                reproduction_probability = draw_from_parameter(bundle.reproduction_probability)
            )
