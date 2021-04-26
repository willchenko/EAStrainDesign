function prodnetCMCSFn(prodnet,prod_frac,n_del)
%% calculate max theoretical yield
% cobra fba
P_max_molar_yield = [];
for i = 1:prodnet.n_prod 
    moi = prodnet.model_array(i);
    roi = char(moi.product_secretion_id);
    %roi = 'EX_etoh_e';
    sr = char(moi.substrate_uptake_id);
    nom = changeObjective(moi,roi);
    rxn_id = find(strcmp(moi.rxns, roi));
    s_id = find(strcmp(moi.rxns, sr));
    fnom = optimizeCbModel(nom);
    v = fnom.v;
    rxn_flux = v(rxn_id);
    s_flux = v(s_id);
    max_molar_yield = rxn_flux/(abs(s_flux));
    P_max_molar_yield = [P_max_molar_yield, max_molar_yield];
end

P_min_product_yield = prod_frac*P_max_molar_yield;
%% setting up cna and cMCS
javaaddpath('C:\Program Files\IBM\ILOG\CPLEX_Studio128\cplex\lib\cplex.jar')
javaaddpath('C:\Users\Owner\Documents\PhD_stuff\research\CellNetAnalyzer\code\cna_java_classes.jar')
addpath('C:\Program Files\IBM\ILOG\CPLEX_Studio128\cplex\matlab')
%ccd 'C:\Users\Owner\Documents\PhD_stuff\research\CellNetAnalyzer'
addpath('C:\Users\Owner\Documents\PhD_stuff\research\CellNetAnalyzer')
startcna(1)

%% converting prodnet.model_array to cna_array
for i = 1:prodnet.n_prod
    model = prodnet.model_array(i);
    cna_model = CNAcobra2cna(model);
    cna_array(i) = cna_model;
end

%% run cMCS algorithm
cand = [prodnet.candidates.reactions.growth.ind; prodnet.candidates.reactions.non_growth.ind]';
cand = unique(cand);
n_sol = 100000;
for sol_id = 1:prodnet.n_prod
    cna_model = cna_array(sol_id);
    moi = prodnet.model_array(sol_id);
    min_product_yield = P_min_product_yield(sol_id);
    roi = char(moi.product_secretion_id);
    sr = char(moi.substrate_uptake_id);
    mue_id = char(moi.biomass_reaction_id);
    rxn_id = find(strcmp(moi.rxns, roi));
    s_id = find(strcmp(moi.rxns, sr));

    [cmcs] = cmcs_fn(cna_model,roi,sr,mue_id,min_product_yield,cand,n_del,n_sol);

    %% write results to excel
    filename = strcat(char(prodnet.prod_id(sol_id)),'-',num2str(prod_frac*100),'-',num2str(n_del));
    matrix = [{'Design'},{'Rxn Deletions'}];
    %writecell(headers,filename)
    [ncmcs,~] = size(cmcs);
    for j = 1:ncmcs
        del_rxns = prodnet.parent_model.rxns(find(cmcs(j,:)));
        row = [{j},{combine_cell_array_to_string(del_rxns)}];
        matrix = [matrix;row];
    end
    xlswrite(filename,matrix)
end
end