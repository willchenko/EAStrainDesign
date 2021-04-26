% run modcell

max_deletions = 20;
max_additions = 0;
pop_size = 110;
ngen = 100;
objective = 'wGCP';
min_growth_rate = 0.01;
max_time = 60*60*5;
starting_beta.blah = [];
% with starting deletions given
[x,fval,output,population,scores] = modcell_design(prodnet,cand,max_deletions,max_additions,objective,min_growth_rate,pop_size,ngen,starting_deletions,starting_beta,max_time)
% with intial population given
[x,fval,output,population,scores] = modcell_design_w_initial_pop_given(prodnet,cand,max_deletions,max_additions,objective,min_growth_rate,pop_size,ngen,starting_beta,max_time,initial_population)

