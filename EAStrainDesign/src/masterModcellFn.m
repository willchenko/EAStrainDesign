function masterModcellFn(alpha,beta,max_time)
l = load('prodnet.mat');
prodnet = l.prodnet;
cand = prodnet.candidates.reactions.growth.ind;
max_deletions = alpha;
max_additions = beta;
pop_size = 400;
ngen = 500;
objective = 'wGCP';
min_growth_rate = 0.01;
starting_deletions = [{'LDH_D'},{'PTAr'},{'ACALD'},{'FUM'},{'PSERT'},{'FUM'},{'PDH'},{'ATPS4rpp'},{'THD2pp'},{'ALCD2x'},{'GND'}];
starting_beta.blah = [];
[x,fval,output,population,scores] = modcell_design(prodnet,cand,max_deletions,max_additions,objective,min_growth_rate,pop_size,ngen,starting_deletions,starting_beta,max_time);
end