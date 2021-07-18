torre_data = GPU_Torre_FrontEnd;
torre.fieldnames_aux = fieldnames(torre_data);
for torre_i = 1 : length(torre.fieldnames_aux)
torre.(torre.fieldnames_aux{torre_i}) = torre_data.(torre.fieldnames_aux{torre_i});
end
torre = rmfield(torre,'fieldnames_aux');

torre_init_parameters;

set(torre.h_frontend_parameters_panel,'columnformat',{'char','char',torre.parameter_types_cell,torre.parameter_methods_cell,'char'});
set(torre.h_frontend_find_in_parameters_panel,'ButtonPushedFcn','torre_find_parameters;');
set(torre.h_frontend_find_category,'ValueChangedFcn','torre_find_parameters;torre.find_category = torre.h_frontend_find_category.Value;');
set(torre.h_frontend_menu_add_parameters_panel,'MenuSelectedFcn','torre_add_parameter;');
set(torre.h_frontend_menu_delete_parameters_panel,'MenuSelectedFcn','torre_delete_parameters;');
set(torre.h_frontend_parameters_panel,'CellSelectionCallback', @torre_parameters_selection);
set(torre.h_frontend_description,'ValueChangedFcn','torre.h_frontend_parameters_panel.Data(torre.parameters_selected(1),end) = torre.h_frontend_description.Value;torre_update_parameters;');
set(torre.h_frontend_apply_parameters,'ButtonPushedFcn','evalin(''base'',''parameters(torre.find_category)'');');
set(torre.h_frontend_clear_parameters,'ButtonPushedFcn','evalin(''base'',''parameters_clear(torre.find_category)'');');

set(torre.h_frontend,'DeleteFcn','torre_close_tools; rmpath(torre_dir); clear torre; clear torre_data;');
set(torre.h_frontend,'Name',[torre.gputorre_name ' Frontend: Parameters tool']);
set(torre.h_frontend_parameters_panel,'CellEditCallback','torre_update_parameters;');
set(torre.h_frontend_find_category,'Items',[{'All'} torre.parameter_types_cell]);
set(torre.h_frontend_find_category,'Value','All');
set(torre.h_frontend_menu_save_project_as,'MenuSelectedFcn','torre_save_project_as;');
set(torre.h_frontend_menu_save_project,'MenuSelectedFcn','torre_save_project;');
set(torre.h_frontend_menu_open_project,'MenuSelectedFcn','torre_open_project;');
set(torre.h_frontend_menu_export_parameters,'MenuSelectedFcn','torre_export_parameters;');
set(torre.h_frontend_menu_export_parameters_as,'MenuSelectedFcn','torre_export_parameters_as;');
set(torre.h_frontend_menu_export_script_pipeline_as_script,'MenuSelectedFcn','torre_export_script_pipeline_as_script;');
set(torre.h_frontend_menu_export_script_pipeline_as,'MenuSelectedFcn','torre_export_script_pipeline_as;');
set(torre.h_frontend_menu_import_parameters,'MenuSelectedFcn','torre_import_parameters;');
set(torre.h_frontend_menu_import_script_pipeline,'MenuSelectedFcn','torre_import_script_pipeline;');
set(torre.h_frontend_menu_files_tool,'MenuSelectedFcn','torre_frontend_open_files_tool;');
set(torre.h_frontend_menu_bank_tool,'MenuSelectedFcn','torre_frontend_open_bank_tool;');
set(torre.h_frontend_menu_script_pipeline,'MenuSelectedFcn','torre_frontend_open_script_pipeline;');
set(torre.h_frontend_menu_parameters_tool,'MenuSelectedFcn','torre_frontend_close; torre_frontend_open;');

set(torre.h_frontend,'AutoResizeChildren','off');
torre.frontend_current_size = get(torre.h_frontend,'Position');
torre.frontend_relative_size = torre_get_relative_size(torre.h_frontend);
set(torre.h_frontend,'SizeChangedFcn','torre.frontend_current_size = torre_change_size_function(torre.h_frontend,torre.frontend_current_size,torre.frontend_relative_size);');

set(findobj(torre.h_frontend.Children,'-property','FontSize'),'FontSize',torre.fontsize);

set(torre.h_frontend,'Position',[12   131   749   703]);