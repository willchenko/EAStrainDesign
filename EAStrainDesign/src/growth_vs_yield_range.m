function [max_product_yield_vector,min_product_yield_vector,growth_vector] = growth_vs_yield_range(model, product_secretion_id, growth_id,sugar_id,number_of_points)
% Objective: Calculate phenotypic space of product vs growth
% Step 1: Get reaction indexes
product_index = find(strcmp(model.rxns, product_secretion_id));
growth_index = find(strcmp(model.rxns, growth_id));
sugar_index = find(strcmp(model.rxns,sugar_id));
% Step 2: calculate maximum growth
nom = changeObjective(model,growth_id);
fnom = optimizeCbModel(nom,'max');
if fnom.stat == 1
    v = fnom.v;
    mue_max = v(growth_index);
else
    mue_max = 0;
end
% Step 3: Get min/max at each growth point 
growth_points = [0:number_of_points]*(mue_max/number_of_points);
[~,lgp] = size(growth_points);
max_product_yield_vector = [];
min_product_yield_vector = [];
growth_vector = [];
for i = 1:lgp
    i
    current_gp = growth_points(i);
    %set growth rate to growth point index
    model.lb(growth_index) = current_gp;
    model.ub(growth_index) = current_gp;
    %get max/min flux of product
    nom = changeObjective(model,product_secretion_id);
    max_fnom = optimizeCbModel(nom,'max');
    min_fnom = optimizeCbModel(nom,'min');
    f = fieldnames(max_fnom);
    %if isempty(find(strcmp(f,'v') ~= 0))
     %   max_fnom = min_fnom;
   % end
    %if max_fnom.obj == 0
     %   max_fnom = min_fnom;
    %end
    %max_v = max_fnom.f;
    %min_v = min_fnom.f;
    max_product_flux = max_fnom.f;
    if max_fnom.stat == 1
        max_sugar_flux = max_fnom.v(sugar_index);
    else
        max_sugar_flux = 10;
    end
    min_product_flux = min_fnom.f;
    if min_fnom.stat == 1
        min_sugar_flux = min_fnom.v(sugar_index);
    else 
        min_sugar_flux = 10;
    end
    max_product_yield = max_product_flux/abs(max_sugar_flux);
    min_product_yield = min_product_flux/abs(min_sugar_flux);
    max_product_yield_vector = [max_product_yield_vector, max_product_yield];
    min_product_yield_vector = [min_product_yield_vector, min_product_yield];
    growth_vector = [growth_vector, current_gp];
end

end

