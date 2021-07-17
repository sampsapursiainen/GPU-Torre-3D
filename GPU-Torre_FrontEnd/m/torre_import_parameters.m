
[torre.file torre.file_path] = uigetfile('*.dat','Import parameters');
if not(isequal(torre.file,0));
torre_frontend_close;
torre_data = readcell([torre.file_path torre.file]);
if size(torre_data,2) < torre.parameters_size_aux
    torre_data(:,torre.parameters_size_aux) = {''};
end
for torre_i = 1 : size(torre_data,1)
if ismissing(torre_data{torre_i,torre.parameters_size_aux})
torre_data{torre_i,torre.parameters_size_aux} = '';
end
end
torre.parameters_data = torre_data;
clear torre_data;
torre_frontend_open;
end