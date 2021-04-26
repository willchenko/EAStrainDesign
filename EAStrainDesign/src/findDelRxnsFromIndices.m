function [del_rxns] = findDelRxnsFromIndices(indices,del_rxn_matrix,cand,prodnet,deletion_integer)
% deletion_integer - what number shows if the rxn is deleted (0 or 1)
del_rxns = [];
for i = 1:length(indices)
    j = indices(i);
    del_rxns = [del_rxns;{combine_cell_array_to_string(prodnet.parent_model.rxns(cand(find(del_rxn_matrix(j,:)==deletion_integer))))}];
end
end