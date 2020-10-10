module Treatments
    # -------------------------------------------------------------
    #   Libraries
    # -------------------------------------------------------------
    using ..MetapopulationDynamics
    using DataFrames
    using ProgressMeter
    using Distributions: DiscreteUniform
    using Random: shuffle!



    # -----------------------------------------------------------
    # Include methods
    # -----------------------------------------------------------
    include(joinpath(".", "types.jl"))
    include(joinpath(".", "create_treatments.jl"))
    include(joinpath(".", "run_treatments.jl"))
    include(joinpath(".", "create_metadata_dataframe.jl"))

    # -----------------------------------------------------------
    # export
    # -----------------------------------------------------------

    export  TreatmentInstance,
            Treatment,
            TreatmentSet
    export run_treatment, run_treatments, create_treatments_from_param_dictionary
end
