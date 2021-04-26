function bd = getBestDesigns(file)
% designed for chassis file
m = readtable(file);
[n_rows,n_cols] = size(m);
obj = m{:,2:n_cols};
bd = [];
for i = 1:n_rows
    max_obj = max(obj(i,:));
    if max_obj ~= 0 && ~isnan(max_obj)
        max_obj_i = find(obj(i,:) == max_obj);
    else
        max_obj_i = 0;
    end
    bd = [bd;max_obj_i];
end

end