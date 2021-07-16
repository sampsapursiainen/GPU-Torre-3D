if not(isempty(torre.save_file_path)) & not(torre.save_file_path==0)
[torre.file torre.file_path] = uiputfile('*.mat','Save as...',[torre.save_file_path torre.save_file]);
else
[torre.file torre.file_path] = uiputfile('*.mat','Save as...');
end
if not(isequal(torre.file,0));
torre_frontend_close;
close(findall(groot,'Type','Figure'));
torre.save_file = torre.file;
torre.save_file_path = torre.file_path;
torre_data = torre;
torre_remove_object_fields;
save([torre.save_file_path torre.save_file],'torre_data','-v7.3');
clear torre_data;
torre_frontend_open;
end