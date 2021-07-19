if not(isempty(torre.save_file_path)) & not(torre.save_file_path==0)
[torre.file torre.file_path] = uiputfile('*.m','Export script pipeline as script',[torre.save_file_path]);
else
[torre.file torre.file_path] = uiputfile('*.m','Export script pipeline as script');
end
if not(isequal(torre.file,0));

torre_data = torre.script_pipeline;    
torre.aux_file = fopen([torre.file_path torre.file],'w');

for torre_i = 1 : size(torre.h_frontend_files_panel.Data,1)

    [~,torre.aux_field] = fileparts(torre.h_frontend_files_panel.Data{torre_i,1});   
    if not(isempty(torre.h_frontend_files_panel.Data{torre_i,2}))
     fprintf(torre.aux_file, '%s\n',[torre.aux_field torre.h_frontend_files_panel.Data{torre_i,2}]);
    else
    fprintf(torre.aux_file, '%s\n',[torre.aux_field]);  
    end
  
end

fclose(torre.aux_file);

clear torre_data;
torre = rmfield(torre,{'aux_file','aux_field'});
end