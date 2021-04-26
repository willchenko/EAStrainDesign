function plotRxnDeletionFrequency(filename)
% make rxn deletion frequency chart
m = readtable(filename);
[ndesigns,~] = size(m);
del_rxns = [];
for i = 1:ndesigns
    design = m(i,:);
    alpha = strsplit(char(design{:,2}),',');
    del_rxns = [del_rxns,alpha];
end

unique_del_rxns = unique(del_rxns);
freq = [];
for i = 1:length(unique_del_rxns)
    n = length(find(ismember(del_rxns,unique_del_rxns(i))));
    f = n/ndesigns;
    freq = [freq,f];
end

[sorted_freq, new_indices] = sort(freq,'descend'); % sorts in *ascending* order
sorted_labels = unique_del_rxns(new_indices);

barh(sorted_freq)
yticks(1:length(unique_del_rxns))
yticklabels(sorted_labels)
ylabel('Deleted Rxn')
xlabel('Frequency')

end
