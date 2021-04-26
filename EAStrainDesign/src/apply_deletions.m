function [new_model] = apply_deletions(model,del_rxns)
% This fn serves to delete rxns from a model, and create a new model
% ex: del_rxns = [{'LDH_D'},{'PTAr'}]
    new_model = model;
    for i = 1:length(del_rxns)
        rxn = del_rxns(i);
        rxn_ind = findRxnIDs(new_model,rxn);
        new_model.ub(rxn_ind) = 0;
        new_model.lb(rxn_ind) = 0;
    end
end