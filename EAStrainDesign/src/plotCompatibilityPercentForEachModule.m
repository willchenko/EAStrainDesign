function plotCompatibilityPercentForEachModule(prodnet,filename,threshold)
m = readtable(filename);
[ndesigns,ncols] = size(m);
nmod = (ncols-2)/2;
start_col = ncols - nmod + 1;
percent = [];
for j = start_col:ncols
    module = m(:,j);
    ncomp = length(find(module{:,:} > threshold));
    percent = [percent;(ncomp/ndesigns)*100];
end
labels = prodnet.prod_name;
[sorted_percent, new_indices] = sort(percent,'descend'); 
sorted_labels = labels(new_indices);

bar(sorted_percent)
xticks([1:prodnet.n_prod])
xticklabels(sorted_labels')
xtickangle(90)
ylabel('Percentage of Compatible Designs')
end
