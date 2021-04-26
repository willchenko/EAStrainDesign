function del_rxn_matrix = createDelRxnMatrix(filename,prodnet,cand)
m = readtable(filename);
[n_sol,~] = size(m);
del_rxn_matrix = [];
for i = 1:n_sol
    design = m(i,:);
    alpha = strsplit(char(design{:,2}),',');
    alpha_cand_i = find(ismember(cand,findRxnIDs(prodnet.parent_model,alpha)));
    row = ones(1,length(cand));
    row(alpha_cand_i) = 0;
    del_rxn_matrix = [del_rxn_matrix;row];
end
end