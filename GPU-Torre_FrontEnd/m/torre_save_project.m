if questdlg('Overwrite the current project file?'); 
torre_frontend_close;
close(findall(groot,'Type','Figure'));
torre_data = torre;
torre_remove_object_fields;
save([torre.save_file_path torre.save_file],'torre_data','-v7.3');
clear torre_data;
torre_frontend_open;
end