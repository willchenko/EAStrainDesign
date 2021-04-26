% compare my results with sergio's
s_del_rxn_matrix = createDelRxnMatrix('wGCP-4-0-sergio.csv',prodnet,cand);
w_del_rxn_matrix = createDelRxnMatrix('wGCP-6-1.csv',prodnet,cand);
[n_sol_w,~] = size(w_del_rxn_matrix);
[n_sol_s,~] = size(s_del_rxn_matrix);
sim = [];
for i = 1:n_sol_w
    w_i = w_del_rxn_matrix(i,:);
    e = [];
    for j = 1:n_sol_s
        s_j = s_del_rxn_matrix(j,:);
        if isequal(s_j,w_i)
            e = [e;1];
        else
            e = [e;0];
        end
    end
    same_rows = find(e == 1);
    if isempty(same_rows)
        sim = [sim;0];
    else
        sim = [sim;same_rows(1)];
    end
end

% compare obj matrices
w_obj = createObjMatrix('wGCP-6-1.csv');
s_obj = createObjMatrix('wGCP-4-0-sergio.csv');
obj_sim = [];
for i = 1:n_sol_w
    w_i = w_obj(i,:);
    e = [];
    for j = 1:n_sol_s
        s_j = s_obj(j,:);
        if isequal(s_j,w_i)
            e = [e;1];
        else
            e = [e;0];
        end
    end
    same_rows = find(e == 1);
    if isempty(same_rows)
        obj_sim = [obj_sim;0];
    else
        obj_sim = [obj_sim;same_rows(1)];
    end
end

obj_sim_i = find(obj_sim~=0);
sim_i = find(sim~=0);

unique([obj_sim(obj_sim_i);sim(sim_i)])

unique([obj_sim_i;sim_i])

[w_max_obj,w_max_obj_i] = findMaxObj(w_obj);
[s_max_obj,s_max_obj_i] = findMaxObj(s_obj);
plotComparingTwoSolutions(prodnet,w_max_obj,s_max_obj)

max_obj = [];
max_obj_i = [];

[w_max_obj,w_max_obj_i] = findMaxObj(obj_5);
max_obj = [max_obj;w_max_obj];
max_obj_i = [max_obj_i;w_max_obj_i];

bar(mc_obj')
xticklabels(prodnet.prod_name)
xtickangle(90)
legend('1','2','3','4','5')


[w_mc_obj,w_mc_i,w_comp] = getMostCompatibleDesign(w_obj,0.5);
[s_mc_obj,s_mc_i,s_comp] = getMostCompatibleDesign(s_obj,0.5);
plotComparingTwoSolutions(prodnet,w_mc_obj,s_mc_obj)

mc_obj = [];
mc_obj_i = [];
comp = [];

[w_mc_obj,w_mc_i,w_comp] = getMostCompatibleDesign(obj_5,0.5);
mc_obj = [mc_obj;w_mc_obj];
mc_obj_i = [mc_obj_i;w_mc_i];
comp = [comp;w_comp];

plotRxnDeletionFrequency('wGCP-4-0-sergio.csv')
plotRxnDeletionFrequencyFromDelMatrix(w_del_rxn_matrix,prodnet,cand,0)

plotRxnDeletionFrequencyFromDelMatrix(del_rxn_matrix_1,prodnet,cand,1)


[del_rxns] = findDelRxnsFromIndices(w_mc_i,w_del_rxn_matrix,cand,prodnet,0)

[del_rxns] = findDelRxnsFromIndices(mc_obj_i(1,:),del_rxn_matrix_1,cand,prodnet,1)


