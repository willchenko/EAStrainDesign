function [product_obj,growth_rate] = calculate_objective(model,objective)
% this function is designed to calculate the fitness of a given model
% required fields of the model: product_id, biomass_id, biomass_ind,
%   product_ind
% designed to work with a model from Prodnet.model_array
switch objective
    case 'wGCP'
        biomass_id = model.rxns(model.biomass_reaction_ind);
        model = changeObjective(model,biomass_id);
        fnom = optimizeCbModel(model,'max');
        growth_rate = fnom.f;
        if growth_rate < .01
            product_rate = 0;
        else
            model.lb(model.biomass_reaction_ind) = growth_rate;
            model.ub(model.biomass_reaction_ind) = growth_rate;
            model = changeObjective(model,model.rxns(model.product_secretion_ind));
            fnom = optimizeCbModel(model,'min');
            if fnom.stat == 1
                product_rate = fnom.v(model.product_secretion_ind);
            else
                product_rate = 0;
            end
        end
        product_obj = product_rate/model.max_product_rate;
    case 'NGP'
        model.lb(model.biomass_reaction_ind) = 0;
        model.ub(model.biomass_reaction_ind) = 0;
        model = changeObjective(model,model.rxns(model.product_secretion_ind));
        fnom = optimizeCbModel(model,'min');
        product_rate = fnom.f;
        growth_rate = 0;
        product_obj = product_rate/model.max_product_rate;
    case 'sGCP'
        biomass_id = model.rxns(model.biomass_reaction_ind);
        model = changeObjective(model,biomass_id);
        fnom = optimizeCbModel(model,'max');
        growth_rate = fnom.f;
        if growth_rate < .01
            max_growth_product_rate = 0;
        else
            if fnom.stat == 1
                max_growth_product_rate = fnom.v(model.product_secretion_ind);
            else
                max_growth_product_rate = 0;
            end
        end
        model.lb(model.biomass_reaction_ind) = 0;
        model.ub(model.biomass_reaction_ind) = 0;
        model = changeObjective(model,model.rxns(model.product_secretion_ind));
        fnom = optimizeCbModel(model,'min');
        non_growth_min_product_rate = fnom.f;
        product_obj = (non_growth_min_product_rate*max_growth_product_rate)/(model.max_product_rate^2);
    end
end