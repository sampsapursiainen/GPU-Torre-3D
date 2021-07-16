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
if size(torre_data,2) < 4
    torre_data(:,4) = {''};
end
for torre_i = 1 : size(torre_data,1)
if ismissing(torre_data{torre_i,4})
torre_data{torre_i,4} = '';
end
end
torre.parameters_data = torre_data;
clear torre_data;
parameters;

torre_frontend_open;

end



     
            
            

