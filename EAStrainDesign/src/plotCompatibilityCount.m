function plotCompatibilityCount(filename,threshold)
m = readtable(filename);
[ndesigns,ncols] = size(m);
nmod = (ncols-2)/2;
start_col = ncols - nmod + 1;
ncomp = [];
for i = 1:ndesigns
    design = m(i,:);
    ncomp = [ncomp;length(find(design{:,start_col:ncols}>threshold))];
end
count = [];
for i = 1:max(ncomp)
    count = [count;length(find(ncomp == i))];
end

bar(count)
xticks([1:max(ncomp)])
xlabel('Compatibility')
ylabel('Count')

end