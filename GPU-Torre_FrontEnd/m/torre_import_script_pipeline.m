[torre.file torre.file_path] = uigetfile('*.dat','Import script pipeline');
if not(isequal(torre.file,0));
torre_frontend_close;
torre.script_pipeline = readcell([torre.file_path torre.file]);
for torre_i = 1 : size(torre_data,1)
    for torre_j = 2 : torre.script_pipeline_size_aux
if ismissing(torre_data{torre_i,torre_j})
torre_data{torre_i,torre_j} = '';
end
end
clear torre_data;
torre_frontend_open;
end