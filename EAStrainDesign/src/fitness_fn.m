function fitness = fitness_fn(prodnet,cand,max_deletions,max_additions,objective,min_growth_rate,x)
    %x = round(x);
    x = logical(x);
    alpha = x(1:length(cand));
    del_rxn_ind = cand(find(alpha == 0));
    if length(del_rxn_ind) > max_deletions
        fitness = zeros(1,prodnet.n_prod);
    else
        fitness = [];
        for i = 1:prodnet.n_prod
            beta = x(length(cand)*i+1:length(cand)*i+length(cand));
            module_additions_ind = cand(find(beta == 0));
            if length(module_additions_ind) > max_additions
                module_fitness = 0;
            else
                module_del_rxn_ind = setdiff(del_rxn_ind,module_additions_ind);
                model = prodnet.model_array(i);
                if ismember({'fixed_module_rxn_ind'},fields(model))
                    module_del_rxn_ind = setdiff(module_del_rxn_ind,model.fixed_module_rxn_ind);
                end
                del_rxns = model.rxns(module_del_rxn_ind);
                new_model = apply_deletions(model,del_rxns);
                [product_obj,growth_rate] = calculate_objective(new_model,objective);
                if growth_rate < min_growth_rate
                    module_fitness = 0;
                else
                    module_fitness = product_obj;
                end
            end
            fitness = [fitness,module_fitness];
        end
    end
end