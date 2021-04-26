function nzp = findEmptyDesigns(file,prodnet)
m = readtable(file);
[nr,nc] = size(m);
obj = m{1:nr,nc-prodnet.n_prod+1:nc};
nzp = [];
for i = 1:prodnet.n_prod
    if isempty(find(obj(:,i) > .0001))
       nzp = [nzp;i]; 
    end
end
end