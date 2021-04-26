function plotParetoHeatMap(prodnet,filename)
m = readtable(filename);
[ndesigns,ncols] = size(m);
nmod = (ncols-2)/2;
start_col = ncols - nmod + 1;
obj_matrix = [];
d_i = [];
for i = 1:ndesigns
    design = m(i,:);
    d_i = [d_i;{num2str(i)}];
    obj_matrix = [obj_matrix;design{:,start_col:ncols}];
end

yv = prodnet.prod_name;
h = heatmap(d_i,yv,obj_matrix');
h.XLabel = 'Design Index';
end