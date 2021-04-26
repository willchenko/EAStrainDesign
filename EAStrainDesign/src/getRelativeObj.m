function getRelativeObj(soln_file,max_file,filename,prodnet)
sf = readtable(soln_file);
mf = readtable(max_file);
[nr_m,~] = size(mf);
max_obj = mf{1:nr_m,2}';
[nr_f,nc_f] = size(sf);
rel_matrix = [];
beta = [];
del_rxns = [];
for i = 1:nr_f
    row = sf{i,nc_f-nr_m+1:nc_f};
    rel_row = row./max_obj;
    for j = 1:length(rel_row)
        if rel_row(j) == 0
            rel_row(j) = .0001;
        end
    end
    rel_matrix = [rel_matrix;rel_row];
    beta = [beta;sf{i,3:nc_f-nr_m}];
    del_rxns = [del_rxns;sf{i,2}];
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
cell_string = strcat('A',num2str(2),':','A',num2str(nr_f+1));
writematrix([1:nr_f]',filename,'Sheet',1,'Range',cell_string)
% write del rxns
cell_string = strcat('B',num2str(2),':','B',num2str(nr_f+1));
writecell(del_rxns,filename,'Sheet',1,'Range',cell_string)
% write beta
%cell_string = strcat('C',num2str(2),':',num2xlcol(2+prodnet.n_prod),num2str(nr_f+1));
%writematrix(beta,filename,'Sheet',1,'Range',cell_string)
% write rel matrix
cell_string = strcat(num2xlcol(2+prodnet.n_prod+1),num2str(2),':',num2xlcol(n_cols),num2str(nr_f+1));
writematrix(rel_matrix,filename,'Sheet',1,'Range',cell_string)

end