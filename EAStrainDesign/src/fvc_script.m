
% flux variance coupling 

%  get WT fluxes
model = prodnet.parent_model;
n_rxns = length(model.rxns);
% aerobic
model.ub(findRxnIDs(model,'EX_o2_e')) = 1000;
model.lb(findRxnIDs(model,'EX_o2_e')) = -1000;
fnom = optimizeCbModel(model);
aer_ref_v = fnom.v;
% anaerobic
model.ub(findRxnIDs(model,'EX_o2_e')) = 0;
model.lb(findRxnIDs(model,'EX_o2_e')) = 0;
fnom = optimizeCbModel(model);
anaer_ref_v = fnom.v;
% get nzf
nzf = union(find(anaer_ref_v ~=0),find(aer_ref_v ~=0));

m = readtable(input_file);
prodnet = get_max_product_rates(prodnet);
[n_rows,n_cols] = size(m);
obj = [];
P_dv = [];
for design_number = 1:5
    for i = 52:71
        model = prodnet.model_array(i);
        design = m(design_number,:);
        del_rxns = strsplit(char(design{:,3}),'; ');
        new_model = apply_deletions(model,del_rxns);
        v = getFluxes(new_model,'wGCP');
        del_rxns_i = findRxnIDs(new_model,del_rxns);
        if isempty(find(del_rxns_i==findRxnIDs(new_model,'EX_o2_e')))
            % aerobic
            dv = abs(abs(aer_ref_v) - abs(v(1:n_rxns)));
            P_dv = [P_dv;find(dv > 2)];
        else
            % anaerobic
            dv = abs(abs(anaer_ref_v) - abs(v(1:n_rxns)));
            P_dv = [P_dv;find(dv > 2)];
        end
    end
end

for design_number = 1:n_rows
    design = m(design_number,:);
    del_rxns = strsplit(char(design{:,3}),'; ');
    obj_i = [];
    for i = 1:prodnet.n_prod
        model = prodnet.model_array(i);
        if ismember({'fixed_module_rxn_ind'},fields(model))
            del_rxns = setdiff(del_rxns,model.rxns(model.fixed_module_rxn_ind));
        end
        product_secretion_id = model.rxns(model.product_secretion_ind);
        growth_id = model.rxns(model.biomass_reaction_ind);
        sugar_id = model.rxns(model.substrate_uptake_ind);
        new_model = apply_deletions(model,del_rxns);
        v = getFluxes(new_model,'wGCP');
        del_rxns_i = findRxnIDs(new_model,del_rxns);
        
        if isempty(find(del_rxns_i==findRxnIDs(new_model,'EX_o2_e')))
            % aerobic
            dv = abs(abs(aer_ref_v) - abs(v(1:n_rxns)));
            model.rxns(find(dv > 200))
        else
            % anaerobic
            
        end
    end
    obj = [obj,obj_i];
end

 


