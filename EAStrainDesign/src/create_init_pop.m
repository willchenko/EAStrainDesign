function initial_population = create_init_pop(prodnet,starting_deletions,nvars,cand,pop_size,max_deletions,max_additions)
initial_population = [];
starting_deletions_i  = findRxnIDs(prodnet.parent_model,starting_deletions);
cand_ind = [];
for i = 1:length(starting_deletions)
    cand_ind = [cand_ind,find(cand == starting_deletions_i(i))];
end
%get beta imi indices
beta_start_i = [];
beta_end_i = [];
for i = 1:length(prodnet.prod_id)
    beta_start_i = [beta_start_i,i*length(cand)+1];
    beta_end_i = [beta_end_i,i*length(cand)+length(cand)];
end


for i = 1:ceil(pop_size/2)
    imi = ones(1,nvars);
    imi(cand_ind((randi([1,length(starting_deletions)],1,max_deletions)))) = 0;
    if max_additions > 0
        for j = 1:length(prodnet.prod_id)
            imi(randi([beta_start_i(j),beta_end_i(j)],1,max_additions)) = 0;
        end
    end
    initial_population = [initial_population;imi];
end
for i = ceil(pop_size/2)+1:pop_size
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