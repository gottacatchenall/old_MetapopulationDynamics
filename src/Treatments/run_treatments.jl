function get_treatment_dataframe(treatment::Treatment, summary_stat::Vector{T}) where T <: SummaryStat
    num_replicates::Int64 = treatment.number_of_replicates
    num_summary_stats = length(summary_stat)


    df = DataFrame(
                    treatment=[treatment.id for i in 1:num_replicates],
                    replicate=[i for i in 1:num_replicates]
                    )
    col_ct = 3 
    for s in summary_stat
        insertcols!(df,  col_ct, string(s) => [0.0 for i in 1:num_replicates], makeunique=true)
        a = zeros(num_replicates)
    end

    return df
end

function get_treatment_dataframe(treatment::Treatment, summary_stat::T) where T <: SummaryStat
    num_replicates::Int64 = treatment.number_of_replicates
    df = DataFrame(
                    treatment=[treatment.id for i in 1:num_replicates],
                    replicate=[i for i in 1:num_replicates])
    insertcols!(df, 3, string(summary_stat) => [0.0 for i in 1:num_replicates])

    return df
end


function add_summary_stat_to_treatment_df(df::DataFrame, row::Int, summary_stat::Vector{T}, vals::Vector{Float64}) where T<:SummaryStat
    for (i,s) in enumerate(summary_stat)
        df[string(s)][row] = vals[i]
    end
end

function add_summary_stat_to_treatment_df(df::DataFrame, row::Int,  summary_stat::T, val::Float64) where T<:SummaryStat
    df[string(summary_stat)][row] = val
end

function run_treatment(treatment::Treatment, summary_stat::Union{T, Vector{T}}) where T <: SummaryStat
    treatment_df = get_treatment_dataframe(treatment, summary_stat)     # TODO construct the treatment df with columns as symbols in summary stats

    num_replicates::Int64 = treatment.number_of_replicates
    for r in 1:num_replicates
        inst = draw_instance_from_treatment(treatment)
        run_dynamics_simulation(inst)
        vals = summary_stat(inst.abundance_matrix)
        add_summary_stat_to_treatment_df(treatment_df, r, summary_stat, vals) 
    end

    return treatment_df
end

function draw_instance_from_treatment(treatment::Treatment)
    param_values::ParameterValues = draw_parameter_values(treatment.theta)
    
    metapop = treatment.metapopulation 
    if (typeof(metapop) <: MetapopulationGenerator)
        metapop = metapop()
    end
   
    dispersal_potential = treatment.dispersal_potential
    if (typeof(dispersal_potential) <: DispersalPotentialGenerator)
        dispersal_potential = dispersal_potential(metapopulation=metapop)
    end

    inst = create_dynamics_model_instance(model = treatment.model,
                                          metapopulation = metapop,
                                          dispersal_potential = dispersal_potential,
                                          parameter_values = param_values,
                                          simulation_settings = treatment.simulation_settings)
end


function add_summary_stat_columns_to_df(df::DataFrame, summary_stat::Vector{T}, nrows::Int) where T <: SummaryStat  
    col_ct = 3
    for s in summary_stat
        insertcols!(df, col_ct, string(s) => [0.0 for i in 1:nrows])
        col_ct += 1
    end
end

function add_summary_stat_columns_to_df(df::DataFrame, summary_stat::T, nrows::Int) where T <: SummaryStat  
    insertcols!(df, 3, string(summary_stat) => [0.0 for i in 1:nrows])
end

function create_output_df(treatment_set::TreatmentSet)
	n_treatments::Int64 = length(treatment_set.treatments)
   
    nrows = 0
    for t in (1:n_treatments)
        nrows += treatment_set.treatments[t].number_of_replicates 
    end

    output_df = DataFrame(
                            treatment = zeros(nrows),
                            replicate = zeros(nrows)
                         )

    add_summary_stat_columns_to_df(output_df, treatment_set.summary_stat, nrows)


    return output_df
end


function add_treatment_to_output_df(output_df::DataFrame,
                                    treatment_df::DataFrame,
                                    start_row::Int, summary_stat::Vector{T}) where T <: SummaryStat
    n_replicates = length(treatment_df.treatment)
    end_row = start_row + n_replicates-1

    output_df.treatment[start_row:end_row] = treatment_df.treatment
    output_df.replicate[start_row:end_row] = treatment_df.replicate
    
    for s in summary_stat
        output_df[string(s)][start_row:end_row]  = treatment_df[string(s)]
    end

    return end_row+1
end


function add_treatment_to_output_df(output_df::DataFrame,
                                    treatment_df::DataFrame,
                                    start_row::Int, summary_stat::T) where T <: SummaryStat
    n_replicates = length(treatment_df.treatment)
    end_row = start_row + n_replicates - 1
    output_df.treatment[start_row:end_row] = treatment_df.treatment
    output_df.replicate[start_row:end_row] = treatment_df.replicate
    output_df[string(summary_stat)][start_row:end_row] = treatment_df[string(summary_stat)]

    return end_row+1
end

function run_treatments(treatment_set::TreatmentSet)
	n_treatments::Int64 = length(treatment_set.treatments)
    summary_stat = treatment_set.summary_stat

	treatments::Vector{Treatment} = treatment_set.treatments
    shuffle!(treatments) 
    
    output_df = create_output_df(treatment_set)
    
    current_row = 1
	@showprogress for t in (1:n_treatments)
        treatment_df = run_treatment(treatments[t], summary_stat)
        current_row = add_treatment_to_output_df(output_df, treatment_df, current_row, summary_stat)
    end
    
    treatment_set.output = output_df
end
