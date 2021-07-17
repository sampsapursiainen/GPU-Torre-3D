for torre_i = 1 : size(torre.h_frontend_files_panel.Data,1)

    [~,torre.aux_field] = fileparts(torre.h_frontend_files_panel.Data{torre_i,1});   
    if not(isempty(torre.h_frontend_files_panel.Data{torre_i,2}))
    evalin('base',[torre.aux_field torre.h_frontend_files_panel.Data{torre_i,2} ';']);
    else
    evalin('base',[torre.aux_field ';']);    
    end
  
end

clear torre_i
torre = rmfield(torre,'aux_field');