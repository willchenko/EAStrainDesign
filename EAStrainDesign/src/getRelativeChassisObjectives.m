function getRelativeChassisObjectives(prodnet,input_file,filename,max_file)

m = readtable(input_file);
prodnet = get_max_product_rates(prodnet);
[n_rows,n_cols] = size(m);
obj = [];
P_del_rxns = [];
for design_number = 1:n_rows
    design = m(design_number,:);
    del_rxns = strsplit(char(design{:,2}),',');
    %P_del_rxns = [P_del_rxns;del_rxns];
    P_del_rxns = [P_del_rxns;{num2str(design_number)}];
    obj_i = [];
    for i = 1:prodnet.n_prod
        model = prodnet.model_array(i);
        if ismember({'fixed_module_rxn_ind'},fields(model))
            del_rxns = setdiff(del_rxns,model.rxns(model.fixed_module_rxn_ind));
        end
        product_secretion_id = model.rxns(model.product_secretion_ind);
        growth_id = model.rxns(model.biomass_reaction_ind);
        sugar_id = model.rxns(model.substrate_uptake_ind);
        new_model = apply_deletions(model,del_rxns);
        [product_obj,growth_rate] = calculate_objective(new_model,'wGCP');
        obj_i = [obj_i;product_obj];
    end
    obj = [obj,obj_i];
end

obj = obj';

mf = readtable(max_file);
[nr_m,~] = size(mf);
max_obj = mf{1:nr_m,2}';

rel_matrix = [];
[num_designs,~] = size(obj);
for i = 1:num_designs
    row = obj(i,:);
    rel_row = row./max_obj;
    for j = 1:length(rel_row)
        if rel_row(j) == 0
            rel_row(j) = .0001;
        end
    end
    rel_matrix = [rel_matrix;rel_row];
end


headers = [{'Solution index'},{'rxn Deletions'}];
for i = 1:prodnet.n_prod
    headers = [headers,{strcat(char(prodnet.prod_id(i)),' rxn additions')}];
end
for i = 1:prodnet.n_prod
    headers = [headers,{strcat(char(prodnet.prod_id(i)),' relative objective')}];
end

n_cols = length(headers);
%write headers
writecell(headers,filename)
%write Solution index
cell_string = strcat('A',num2str(2),':','A',num2str(n_rows+1));
writematrix([1:n_rows]',filename,'Sheet',1,'Range',cell_string)
% write del rxns
cell_string = strcat('B',num2str(2),':','B',num2str(n_rows+1));
writecell(P_del_rxns,filename,'Sheet',1,'Range',cell_string)
% write beta
%cell_string = strcat('C',num2str(2),':',num2xlcol(2+prodnet.n_prod),num2str(n_rows+1));
%writematrix(beta,filename,'Sheet',1,'Range',cell_string)
% write rel matrix
cell_string = strcat(num2xlcol(2+prodnet.n_prod+1),num2str(2),':',num2xlcol(n_cols),num2str(n_rows+1));
writematrix(rel_matrix,filename,'Sheet',1,'Range',cell_string)

end