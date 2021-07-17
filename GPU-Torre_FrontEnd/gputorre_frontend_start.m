if exist('torre') 
        if isstruct(torre)
            
            error('Another instance of GPU-Torre is already open.')
            
        end
        
else
    
addpath(genpath(pwd));
torre_init;

torre.fieldnames_aux = fieldnames(torre_data);
for torre_i = 1 : length(torre.fieldnames_aux)
torre.(torre.fieldnames_aux{torre_i}) = torre_data.(torre.fieldnames_aux{torre_i});
end
torre = rmfield(torre,{'fieldnames_aux'});
clear torre_data;

torre_data = readcell('parameters_data.dat');
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
parameters;

torre_frontend_open;
torre_frontend_open_bank_tool;
torre_frontend_open_folder_tool;
torre_frontend_open_script_pipeline



end



     
            
            

