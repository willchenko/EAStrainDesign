function initial_population = getStartingPopulationFromModCellFile(file,sep,prodnet,cand,pop_size,max_deletions,max_additions)
% deletions are in 3rd col
% node is in 2nd
% all rows 

% sep is either ';' or ',' or '; ' or ', '

% get exact deletionss from file
% each row is an individual
m = readtable(file);
[n_rows,n_cols] = size(m);
nvars = length(cand)*prodnet.n_prod + length(cand);
starting_deletions= [];
initial_population = [];
for i = 1:n_rows
    %node_i = char(m{i,2});
    %if sum(strcmp(node_i,node)) ~= 0
    del_rxns = strsplit(char(m{i,2}),sep);
    if strcmp(char(del_rxns),'NA') == 0
        starting_deletions = [starting_deletions,del_rxns];
        del_rxn_ids = findRxnIDs(prodnet.parent_model,del_rxns);
        cand_ind = [];
        for i = 1:length(del_rxn_ids)
            cand_ind = [cand_ind,find(cand == del_rxn_ids(i))];
        end
        row = ones(1,nvars);
        row(cand_ind) = 0;
        initial_population = [initial_population;row];
    end
    %end
end

% randomly generatate rest of population from candidates

[n_ind,~] = size(initial_population);
for i = n_ind+1:pop_size
    imi = ones(1,nvars);
    imi(randi([1,length(cand)],1,max_deletions)) = 0;
    if max_additions > 0
        for j = 1:length(prodnet.prod_id)
            imi(randi([beta_start_i(j),beta_end_i(j)],1,max_additions)) = 0;
        end
    end
    initial_population = [initial_population;imi];
end

end