if not(isempty(torre.save_file_path)) & not(torre.save_file_path==0)
[torre.file torre.file_path] = uiputfile('*.mat','Export parameters as...',[torre.save_file_path]);
else
[torre.file torre.file_path] = uiputfile('*.mat','Export parameters as...');
end
if not(isequal(torre.file,0));

torre_data = torre.parameters_data;    
save([torre.file_path torre.file],'torre_data');

clear torre_data;
end
