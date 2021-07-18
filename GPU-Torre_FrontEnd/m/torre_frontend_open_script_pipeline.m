torre_data = GPU_Torre_FrontEnd_Script_Pipeline;
torre.fieldnames_aux = fieldnames(torre_data);
for torre_i = 1 : length(torre.fieldnames_aux)
torre.(torre.fieldnames_aux{torre_i}) = torre_data.(torre.fieldnames_aux{torre_i});
end
torre = rmfield(torre,'fieldnames_aux');

set(torre.h_frontend_run_files_panel,'ButtonPushedFcn','torre_run_selected_files_list;');
set(torre.h_frontend_menu_add_files_panel,'MenuSelectedFcn','torre_add_selected_files_list;');
set(torre.h_frontend_menu_add_empty_row_files_panel,'MenuSelectedFcn','torre_add_empty_row_files_list;');
set(torre.h_frontend_menu_delete_files_panel,'MenuSelectedFcn','torre_delete_selected_files_list;');
set(torre.h_frontend_menu_move_selected_up_files_panel,'MenuSelectedFcn','torre_move_selected_up_files_list;');
set(torre.h_frontend_script_pipeline,'Name',[torre.gputorre_name ' Frontend: Script pipeline']);
set(torre.h_frontend_files_panel,'CellSelectionCallback', @torre_script_pipeline_selection);
set(torre.h_frontend_files_panel,'CellEditCallback','torre_update_script_pipeline;');
torre.h_frontend_files_panel.Multiselect = 'on';

torre_init_files;

set(torre.h_frontend_script_pipeline,'AutoResizeChildren','off');
torre.frontend_script_pipeline_current_size = get(torre.h_frontend_script_pipeline,'Position');
torre.frontend_script_pipeline_relative_size = torre_get_relative_size(torre.h_frontend_script_pipeline);
set(torre.h_frontend_script_pipeline,'SizeChangedFcn','torre.frontend_script_pipeline_current_size = torre_change_size_function(torre.h_frontend_script_pipeline,torre.frontend_script_pipeline_current_size,torre.frontend_script_pipeline_relative_size);');
set(findobj(torre.h_frontend_script_pipeline.Children,'-property','FontSize'),'FontSize',torre.fontsize);

 set(torre.h_frontend_script_pipeline,'Position',[    1101         411         332         439]);