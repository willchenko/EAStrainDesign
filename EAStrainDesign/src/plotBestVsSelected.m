function plotBestVsSelected(prodnet,filename,selection)
m = readtable(filename);
[ndesigns,ncols] = size(m);
nmod = (ncols-2)/2;
start_col = ncols - nmod + 1;
%ncomp = [];
%for i = 1:ndesigns
%    design = m(i,:);
%    ncomp = [ncomp;length(find(design{:,start_col:ncols}>threshold))];
%end
%mc_design_i = find(ncomp == max(ncomp)); % most compatible design
mc_design = m(selection,:);
mc_obj = mc_design{:,start_col:ncols};
performance = [];
for j = start_col:ncols
    module = m(:,j);
    performance = [performance;max(module{:,:})];
end


labels = prodnet.prod_name;
[sorted_mc_obj, new_indices] = sort(mc_obj,'descend');
sorted_performance = performance(new_indices);
sorted_labels = labels(new_indices);

yyaxis left
b = bar(sorted_performance);
ylim([0 1]);
ylabel('Objective Value')
yyaxis right
p = plot(sorted_mc_obj,'-o');
ylim([0 1]);
xticks([1:prodnet.n_prod])
xticklabels(sorted_labels)
xtickangle(90)

end