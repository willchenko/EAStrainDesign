function str = combine_cell_array_to_string(cell_array)
    str = '';
    for i = 1:length(cell_array)
        if i == 1
            str = strcat(str,char(cell_array(i)));
        else
        str = strcat(str,',',char(cell_array(i)));
        end
    end
end
