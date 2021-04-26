function [x,fval,output,population,scores] = modcell_design(prodnet,cand,max_deletions,max_additions,objective,min_growth_rate,pop_size,ngen,starting_deletions,starting_beta,max_time)
    prodnet = get_max_product_rates(prodnet);
    obj_fun_handle =@(x) - fitness_fn(prodnet,cand,max_deletions,max_additions,objective,min_growth_rate,x);
    nvars = length(cand)*prodnet.n_prod + length(cand);
    initial_population = create_init_pop(prodnet,starting_deletions,nvars,cand,pop_size,max_deletions,max_additions);
    fields = fieldnames(starting_beta);
    for i = 1:length(fields)
        k = find(strcmp(prodnet.prod_id,char(fields(i))));
        b = getfield(starting_beta,char(fields(i)));
        initial_population(k*length(cand)+find(ismember(cand,findRxnIDs(prodnet.parent_model,b)))) = 0;
    end
    options = optimoptions('gamultiobj','InitialPopulationMatrix',initial_population);
    %options.CrossoverFcn = 'crossoverscattered'; %This type of crossover does not connect variable ordering with convergence, unlike single and two point.
    options.MutationFcn =  {'mutationuniform', 0.5 };
    options.PopulationType = 'bitstring';
    options.PopulationSize = pop_size;
    options.MaxGenerations =ngen;
    options.MaxTime = max_time;
    options.PlotFcn = {'gaplotscorediversity','gaplotspread'};
    [x,fval,~,output,population,scores] = gamultiobj(obj_fun_handle,nvars,[],[],[],[],[],[],options);
    saveSolution(prodnet,x,fval,output,population,scores,pop_size,ngen,max_deletions,max_additions,objective)
    filename = strcat(objective,'-',num2str(max_deletions),'-',num2str(max_additions),'.csv');
    write_results_to_excel(prodnet,cand,filename,x,fval)
end