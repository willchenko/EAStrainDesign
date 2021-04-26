function getFVCmatrix(prodnet,design_file,obj_file)
model = prodnet.parent_model;
n_rxns = length(model.rxns);

bd = getBestDesigns('chassis6-obj.xlsx');
% only active modules are used
active_modules = find(bd ~=0);

m = readtable('chassis6.xlsx');
[n_rows,n_cols] = size(m);
fvc_matrix = [];
for i = 1:prodnet.n_prod
    model = prodnet.model_array(i);
    design_number = bd(i);
    if design_number ~= 0
        design = m(design_number,:);
        del_rxns = strsplit(char(design{:,3}),'; ');
        new_model = apply_deletions(model,del_rxns);
        v = getFluxes(new_model,'wGCP');
        fvc_matrix = [fvc_matrix,v(1:n_rxns)];
    end
end

fvc_matrix = abs(fvc_matrix);

% write to excel
output_file = 'chassis6-fvc_matrix.xlsx';
headers = [{'rxn'},prodnet.prod_id(active_modules)'];
cell_string = strcat('A1:',num2xlcol(length(headers)),num2str(1));
writecell(headers,output_file,'Sheet',1,'Range',cell_string)

cell_string = strcat('A2:A',num2str(n_rxns+1));
writecell(model.rxns,output_file,'Sheet',1,'Range',cell_string)

cell_string = strcat('B2:',num2xlcol(length(headers)),num2str(n_rxns+1));
writematrix(fvc_matrix,output_file,'Sheet',1,'Range',cell_string)



P_std = [];
nzf = [];
for j = 1:n_rxns
    if ~isempty(find(fvc_matrix(j,:)>0))
        nzf = [nzf;j];
    end
    P_std = [P_std;std(fvc_matrix(j,:))];
end

std_i = find(P_std > 2);

tr = findTransRxns_updated(model);
er = findExcRxns(model);
er =find(er);
tr = findRxnIDs(model,tr);
dr = unique([tr;er]);

P_std_i = [];
for i=1:length(std_i)
    if isempty(find(dr == std_i(i)))
        P_std_i = [P_std_i;std_i(i)];
    end
end


% write to excel
output_file = 'chassis6-fvc_matrix-2_1.xlsx';
headers = [{'rxn'},prodnet.prod_id(active_modules)'];
cell_string = strcat('A1:',num2xlcol(length(headers)),num2str(1));
writecell(headers,output_file,'Sheet',1,'Range',cell_string)

cell_string = strcat('A2:A',num2str(length(P_std_i)+1));
writecell(model.rxns(P_std_i),output_file,'Sheet',1,'Range',cell_string)

cell_string = strcat('B2:',num2xlcol(length(headers)),num2str(length(P_std_i)+1));
writematrix(fvc_matrix(P_std_i,:),output_file,'Sheet',1,'Range',cell_string)

end

