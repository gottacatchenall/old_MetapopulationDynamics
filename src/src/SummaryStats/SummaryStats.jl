module SummaryStats
    using ..DPE
    using StatsBase 
    abstract type SummaryStat end
    include(joinpath(".", "types.jl"))
    include(joinpath(".", "pcc.jl"))

    export SummaryStat, PCC
end
