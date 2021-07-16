torre_data.fieldnames = fieldnames(torre_data);
torre_data.remove_fieldnames = cell(0);
torre_j = 0;
for torre_i = 1 : length(torre_data.fieldnames)
    if isobject(evalin('base',['torre_data.' torre_data.fieldnames{torre_i}]))
    torre_j = torre_j + 1;
    torre_data.remove_fieldnames{torre_j} = torre_data.fieldnames{torre_i};
    end
end
torre_data = rmfield(torre_data,torre_data.remove_fieldnames);
torre_data = rmfield(torre_data,{'remove_fieldnames','fieldnames'});
clear torre_i torre_j