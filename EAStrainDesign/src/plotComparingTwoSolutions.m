function plotComparingTwoSolutions(prodnet,w_max_obj,s_max_obj)
labels = prodnet.prod_name;

yyaxis left
b = bar(w_max_obj);
ylim([0 1]);
ylabel('Objective Value')
yyaxis right
p = plot(s_max_obj,'-o');
ylim([0 1]);
xticks([1:prodnet.n_prod])
xticklabels(labels)
xtickangle(90)
end