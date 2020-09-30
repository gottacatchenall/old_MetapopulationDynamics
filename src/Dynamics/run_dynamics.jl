function run_dynamics_simulation(inst::DynamicsInstance{RickerModelWStochasticDispersal})
    RickerModelWStochasticDispersal(inst)
end

function run_dynamics_simulation(inst::DynamicsInstance{RickerModelWDiffusionDispersal})
    RickerModelWDiffusionDispersal(inst)
end
