
    # -------------------------------------------------------------
    #   Types
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
        simulation_parameters::SimulationSettings
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
