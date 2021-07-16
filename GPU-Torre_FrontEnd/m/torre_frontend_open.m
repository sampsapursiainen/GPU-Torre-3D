torre_data = GPU_Torre_FrontEnd;
torre.fieldnames_aux = fieldnames(torre_data);
for torre_i = 1 : length(torre.fieldnames_aux)
torre.(torre.fieldnames_aux{torre_i}) = torre_data.(torre.fieldnames_aux{torre_i});
end
torre = rmfield(torre,'fieldnames_aux');

torre_init_parameters;
torre_init_directory;
torre_init_files;
torre_init_bank;

set(torre.h_frontend_parameters_panel,'columnformat',{'char','char',torre.parameter_types_cell,'char'});
set(torre.h_frontend_bank_panel,'columnformat',{torre.bank_item_type_cell,'char'});
set(torre.h_frontend_run_files_panel,'ButtonPushedFcn','torre_run_selected_files_list;');
set(torre.h_frontend_menu_add_files_panel,'MenuSelectedFcn','torre_add_selected_files_list;');
set(torre.h_frontend_menu_delete_files_panel,'MenuSelectedFcn','torre_delete_selected_files_list;');
set(torre.h_frontend_menu_move_selected_up_files_panel,'MenuSelectedFcn','torre_move_selected_up_files_list;');
set(torre.h_frontend_menu_run_files_panel,'MenuSelectedFcn','torre_run_selected_files_list;');
set(torre.h_frontend_menu_refresh_folder_panel,'MenuSelectedFcn','torre_init_directory;');
set(torre.h_frontend_find_in_parameters_panel,'ButtonPushedFcn','torre_find_parameters;');
set(torre.h_frontend_apply_bank_panel,'ButtonPushedFcn','torre_apply_bank_panel;');
set(torre.h_frontend_menu_add_parameters_panel,'MenuSelectedFcn','torre_add_parameter;');
set(torre.h_frontend_menu_delete_parameters_panel,'MenuSelectedFcn','torre_delete_parameters;');
set(torre.h_frontend_menu_add_parameters_bank_panel,'MenuSelectedFcn','torre.add_bank_item_type = 1; torre_add_bank_item;');
set(torre.h_frontend_menu_script_pipeline_bank_panel,'MenuSelectedFcn','torre.add_bank_item_type = 2; torre_add_bank_item;');
set(torre.h_frontend_menu_delete_bank_panel,'MenuSelectedFcn','torre_delete_bank_items;');
set(torre.h_frontend_parameters_panel,'CellSelectionCallback', @torre_parameters_selection);
set(torre.h_frontend_bank_panel,'CellSelectionCallback', @torre_bank_selection);
set(torre.h_frontend,'DeleteFcn','rmpath(torre_dir); clear torre;');
set(torre.h_frontend,'Name',[gputorre_name ' Frontend']);
set(torre.h_frontend_parameters_panel,'CellEditCallback','torre_update_parameters;');
set(torre.h_frontend_find_category,'Items',[{'All'} torre.parameter_types_cell]);
set(torre.h_frontend_find_category,'Value','All');
set(torre.h_frontend_menu_save_project_as,'MenuSelectedFcn','torre_save_project_as;');
set(torre.h_frontend_menu_save_project,'MenuSelectedFcn','torre_save_project;');
set(torre.h_frontend_menu_open_project,'MenuSelectedFcn','torre_open_project;');
set(torre.h_frontend_menu_export_parameters,'MenuSelectedFcn','torre_export_parameters;');
set(torre.h_frontend_menu_export_parameters_as,'MenuSelectedFcn','torre_export_parameters_as;');
set(torre.h_frontend_menu_export_script_pipeline_as,'MenuSelectedFcn','torre_export_script_pipeline_as;');
set(torre.h_frontend_menu_import_parameters,'MenuSelectedFcn','torre_import_parameters;');
set(torre.h_frontend_menu_import_script_pipeline,'MenuSelectedFcn','torre_import_script_pipeline;');

set(torre.h_frontend,'AutoResizeChildren','off');
torre.frontend_current_size = get(torre.h_frontend,'Position');
torre.frontend_relative_size = torre_get_relative_size(torre.h_frontend);
set(torre.h_frontend,'SizeChangedFcn','torre.frontend_current_size = torre_change_size_function(torre.h_frontend,torre.frontend_current_size,torre.frontend_relative_size);');
