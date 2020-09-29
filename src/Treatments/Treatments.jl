module Treatments
    # -------------------------------------------------------------
    #   Libraries
    # -------------------------------------------------------------
    using ..MetapopulationDynamics
    using DataFrames
    using ProgressMeter



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
    export draw_instance_from_treatment
end
