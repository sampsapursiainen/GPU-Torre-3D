
[torre.file torre.file_path] = uiputfile('*.dat','Import parameters');
if not(isequal(torre.file,0));
torre_frontend_close;
torre.parameters_data = readcell([torre.file_path torre.file]);
clear torre_data;
torre_frontend_open;
end