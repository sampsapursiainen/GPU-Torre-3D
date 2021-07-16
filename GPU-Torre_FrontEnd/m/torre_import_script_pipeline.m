[torre.file torre.file_path] = uiputfile('*.dat','Import script pipeline');
if not(isequal(torre.file,0));
torre_frontend_close;
torre.script_pipeline = readcell([torre.file_path torre.file]);
clear torre_data;
torre_frontend_open;
end