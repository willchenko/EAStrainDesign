function saveSolution(prodnet,x,fval,output,population,scores,pop_size,ngen,max_deletions,max_additions,objective)
mop_solution.parameters.pop_size = pop_size;
mop_solution.parameters.ngen = ngen;
mop_solution.prodnet = prodnet;
mop_solution.x = x;
mop_solution.fval = fval;
mop_solution.output = output;
mop_solution.population = population;
mop_solution.scores = scores;
filename = strcat(objective,'-',num2str(max_deletions),'-',num2str(max_additions),'.mat');
save(filename,'mop_solution')
end