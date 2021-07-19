if not(isempty(torre.save_file_path)) & not(torre.save_file_path==0)  
[torre.file torre.file_path] = uigetfile('*.mat','Open project',torre.save_file_path);
else
[torre.file torre.file_path] = uigetfile('*.mat','Open project');
end
if not(isequal(torre.file,0));
   
torre_frontend_close;
    
torre_init;
torre.save_file = torre.file; 
torre.save_file_path = torre.file_path;     
load([torre.file_path torre.file]);  
torre_remove_object_fields;

 torre.fieldnames = fieldnames(torre_data);
 for torre_i = 1:length(torre.fieldnames)
 torre.(torre.fieldnames{torre_i}) = torre_data.(torre.fieldnames{torre_i});
 end
 clear torre_i;
 torre = rmfield(torre,'fieldnames');
 
clear torre_i
 
clear torre_data;

torre_frontend_open;
torre_frontend_open_bank_tool;
torre_frontend_open_folder_tool;
torre_frontend_open_script_pipeline;

end;