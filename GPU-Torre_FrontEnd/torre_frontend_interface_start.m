
torre_data = GPU_Torre_FrontEnd;

torre.h_frontend= torre_data.h_frontend;
torre.h_frontend_parameter_table = torre_data.h_frontend_parameter_table;
torre.h_frontend_apply =  torre_data.h_frontend_apply;

clear torre_data
torre_data = load('parameters_data.mat');


torre_data.fieldnames = fieldnames(torre_data);
torre.h_frontend_parameter_table.Data= torre_data.fieldnames;

torre_data.parametervalues = struct2cell(torre_data);
for torre_i = 1 : length(torre_data.fieldnames)
    torre.h_frontend_parameter_table.Data{torre_i,2} = torre_data.parametervalues{torre_i};
%     assignin('base', torre_data.fieldnames{torre_i}, torre_data.parametervalues{torre_i});
end
clear torre_data

