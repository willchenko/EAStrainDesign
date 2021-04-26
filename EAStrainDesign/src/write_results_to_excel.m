function write_results_to_excel(prodnet,cand,filename,x,fval)
% write results to excel sheet
headers = [{'soliution index'},{'rxn Deletions'}];
for i = 1:prodnet.n_prod
    headers = [headers,{strcat(char(prodnet.prod_id(i)),' rxn additions')}];
end
for i = 1:prodnet.n_prod
    headers = [headers,{strcat(char(prodnet.prod_id(i)),' objective')}];
end

writecell(headers,filename)
num_col = prodnet.n_prod*2+2;
[n_sol,~] = size(x);
for i = 1:n_sol
    design = x(i,:);
    a = design(1:length(cand));
    del_rxn_i = find(a == 0);
    del_rxn = prodnet.parent_model.rxns(cand(del_rxn_i));
    del_rxn_string = combine_cell_array_to_string(del_rxn);
    if isempty(del_rxn_string)
        del_rxn_string = {''};
    end
    beta = [];
    for j = 1:prodnet.n_prod
        b = design(length(cand)*j+1:length(cand)*j+length(cand));
        add_rxn_i = find(b == 0);
        add_rxns = prodnet.parent_model.rxns(cand(add_rxn_i));
        add_rxn_string = combine_cell_array_to_string(add_rxns);
        beta = [beta,{add_rxn_string}];
    end
    obj = -1*[fval(i,:)];
    o = [];
    for j = 1:length(obj)
        o = [o,{obj(j)}];
    end
    cell_string = strcat('A',num2str(i+1),':',num2xlcol(num_col),num2str(i+1));
    xlswrite(filename,[i,del_rxn_string,beta,o],cell_string)
end
end