function plotRxnDeletionFrequencyFromDelMatrix(del_rxn_matrix,prodnet,cand,deletion_integer)
[ndesigns,~] = size(del_rxn_matrix);
del_rxn_i = [];
for i = 1:ndesigns
    del_rxn_i = [del_rxn_i,find(del_rxn_matrix(i,:)==deletion_integer)];
end
unique_rxn_i = unique(del_rxn_i);
freq = [];
for i = 1:length(unique_rxn_i)
    freq = [freq;length(find(del_rxn_i == unique_rxn_i(i)))/ndesigns];
end
unique_del_rxns = prodnet.parent_model.rxns(cand(unique_rxn_i));

[sorted_freq, new_indices] = sort(freq,'descend'); % sorts in *ascending* order
sorted_labels = unique_del_rxns(new_indices);

barh(sorted_freq)
yticks(1:length(unique_del_rxns))
yticklabels(sorted_labels)
ylabel('Deleted Rxn')
xlabel('Frequency')
end