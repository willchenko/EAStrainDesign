function plotPhenoSpaceFromDesign(prodnet,design_file,design_number,nrows,number_of_points)
m = readtable(design_file);
design = m(design_number,:);
alpha = strsplit(char(design{:,2}),',');
WT_max_yield_vectors = [];
WT_min_yield_vectors = [];
WT_growth_vectors = [];
mutant_max_yield_vectors = [];
mutant_min_yield_vectors = [];
mutant_growth_vectors = [];
for i = 1:prodnet.n_prod
    beta = strsplit(char(design{:,2+i}),',');
    del_rxns = setdiff(alpha,beta);
    model = prodnet.model_array(i);
    if ismember({'fixed_module_rxn_ind'},fields(model))
        del_rxns = setdiff(del_rxns,model.rxns(model.fixed_module_rxn_ind));
    end
    product_secretion_id = model.rxns(model.product_secretion_ind);
    growth_id = model.rxns(model.biomass_reaction_ind);
    sugar_id = model.rxns(model.substrate_uptake_ind);
    %number_of_points = 20;
    [max_product_yield_vector,min_product_yield_vector,growth_vector] = growth_vs_yield_range(model, product_secretion_id, growth_id,sugar_id,number_of_points);
    cmol_ratio = model.cmol_ratio;
    max_product_yield_vector = cmol_ratio*max_product_yield_vector;
    min_product_yield_vector = cmol_ratio*min_product_yield_vector;
    WT_max_yield_vectors = [WT_max_yield_vectors; max_product_yield_vector];
    WT_min_yield_vectors = [WT_min_yield_vectors; min_product_yield_vector];
    WT_growth_vectors = [WT_growth_vectors; growth_vector];
    new_model = apply_deletions(model,del_rxns);
    [max_product_yield_vector,min_product_yield_vector,growth_vector] = growth_vs_yield_range(new_model, product_secretion_id, growth_id,sugar_id,number_of_points);
    cmol_ratio = model.cmol_ratio;
    max_product_yield_vector = cmol_ratio*max_product_yield_vector;
    min_product_yield_vector = cmol_ratio*min_product_yield_vector;
    mutant_max_yield_vectors = [mutant_max_yield_vectors; max_product_yield_vector];
    mutant_min_yield_vectors = [mutant_min_yield_vectors; min_product_yield_vector];
    mutant_growth_vectors = [mutant_growth_vectors; growth_vector];
end

figure() ;
ncols = prodnet.n_prod/nrows;
shaded_color = 'b';
 for plotId = 1 : prodnet.n_prod
    [~,lv] = size(WT_growth_vectors(plotId,:));
    header = char(prodnet.prod_name(plotId));
    subplot(nrows, ncols, plotId);
    plot(WT_growth_vectors(plotId,:), WT_max_yield_vectors(plotId,:),'b');
    hold on;
    plot(WT_growth_vectors(plotId,:),WT_min_yield_vectors(plotId,:),'b');
    hold on;
    line([WT_growth_vectors(plotId,lv),WT_growth_vectors(plotId,lv)],[WT_min_yield_vectors(plotId,lv),WT_max_yield_vectors(plotId,lv)],'Color','b')
    hold on;
    plot(mutant_growth_vectors(plotId,:),mutant_max_yield_vectors(plotId,:),shaded_color);
    hold on;
    plot(mutant_growth_vectors(plotId,:),mutant_min_yield_vectors(plotId,:),shaded_color);
    hold on;
    line([mutant_growth_vectors(plotId,lv),mutant_growth_vectors(plotId,lv)],[mutant_min_yield_vectors(plotId,lv),mutant_max_yield_vectors(plotId,lv)],'Color',shaded_color)
    g2 = [mutant_growth_vectors(plotId,:), fliplr(mutant_growth_vectors(plotId,:))];
    inBetween = [mutant_max_yield_vectors(plotId,:), fliplr(mutant_min_yield_vectors(plotId,:))];
    fill(g2, inBetween, shaded_color);
    title(header)
    %if mod(plotId,ncols) == 1
       % yticks([0 0.3 0.6 0.9])
    %else
        %yticks([])
    %end
    if plotId < 0%ncols*(nrows-1)
        xticks([0.00 0.05 0.10 0.15])
    else
        %xticks([])
    end
    ylim([0 1.1*max(WT_max_yield_vectors(plotId,:))])
 end


end
