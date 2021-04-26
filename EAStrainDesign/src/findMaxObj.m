function [max_obj,max_obj_i] = findMaxObj(design_matrix)
[n_designs,n_products] = size(design_matrix);
max_obj = [];
max_obj_i = [];
for i = 1:n_products
    prod_designs = design_matrix(:,i);
    max_obj = [max_obj,max(prod_designs)];
    f = find(prod_designs == max(prod_designs));
    max_obj_i = [max_obj_i,f(1)];
end
end