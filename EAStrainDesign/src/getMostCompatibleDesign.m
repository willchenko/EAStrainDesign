function [mc_obj,mc_i,comp] = getMostCompatibleDesign(obj_matrix,threshold)
[ndesigns,~] = size(obj_matrix);
ncomp = [];
for i = 1:ndesigns
    design = obj_matrix(i,:);
    ncomp = [ncomp;length(find(design > threshold))];
end
mc_i = find(ncomp == max(ncomp)); % most compatible design
mc_i = mc_i(1);
mc_obj = obj_matrix(mc_i,:);
comp = ncomp(mc_i);
end