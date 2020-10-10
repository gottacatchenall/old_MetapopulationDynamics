module SummaryStats
    using ..MetapopulationDynamics
    using StatsBase 
    abstract type SummaryStat end
    include(joinpath(".", "types.jl"))
    include(joinpath(".", "pcc.jl"))
    include(joinpath(".", "mean_abundance.jl"))

    function (vec::Array{T,1})(abundance_matrix::Array{Float64,2}) where T <: SummaryStat
        results::Array{Float64,1} = [0.0 for i in 1:length(vec)]
        for i in 1:length(vec)
            results[i] = vec[i](abundance_matrix)
        end
        return results
    end

    export SummaryStat, PCC, MeanAbundance
end
