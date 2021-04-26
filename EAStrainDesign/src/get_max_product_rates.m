function prodnet = get_max_product_rates(prodnet)
    for i = 1:prodnet.n_prod
        new_model = prodnet.model_array(i);
        obj = new_model.rxns(new_model.product_secretion_ind);
        new_model = changeObjective(new_model,obj);
        new_model.ub(new_model.biomass_reaction_ind) = prodnet.min_growth_rate;
        new_model.lb(new_model.biomass_reaction_ind) = prodnet.min_growth_rate;
        fnom = optimizeCbModel(new_model,'max');
        product_rate = fnom.f;
        prodnet.model_array(i).max_product_rate = product_rate;
    end
end
