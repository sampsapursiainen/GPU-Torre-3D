if not(isempty(torre.save_file_path)) & not(torre.save_file_path==0)
[torre.file torre.file_path] = uiputfile('*.dat','Export parameters as...',[torre.save_file_path]);
else
[torre.file torre.file_path] = uiputfile('*.dat','Export parameters as...');
end
if not(isequal(torre.file,0));

torre_data = torre.parameters_data;    
writecell(torre_data,[torre.file_path torre.file]);

clear torre_data;
end