function pat = getDesignsAboveTol(file,prodnet,tol)
m = readtable(file);
[nr,nc] = size(m);
obj = m{1:nr,nc-prodnet.n_prod+1:nc};
pat = [];
for i = 1:prodnet.n_prod
    if ~isempty(find(obj(:,i) > tol))
       pat = [pat;i]; 
    end
end
end