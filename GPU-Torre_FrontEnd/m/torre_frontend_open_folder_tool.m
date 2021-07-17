torre_data = GPU_Torre_FrontEnd_Folder;
torre.fieldnames_aux = fieldnames(torre_data);
for torre_i = 1 : length(torre.fieldnames_aux)
torre.(torre.fieldnames_aux{torre_i}) = torre_data.(torre.fieldnames_aux{torre_i});
end
torre = rmfield(torre,'fieldnames_aux');

set(torre.h_frontend_menu_refresh_folder_panel,'MenuSelectedFcn','torre_init_directory;');
set(torre.h_frontend_folder_tool,'Name',[gputorre_name ' Frontend: Folder tool']);

torre_init_directory;

set(torre.h_frontend_folder_tool,'AutoResizeChildren','off');
torre.frontend_folder_tool_current_size = get(torre.h_frontend_folder_tool,'Position');
torre.frontend_folder_tool_relative_size = torre_get_relative_size(torre.h_frontend_folder_tool);
set(torre.h_frontend_folder_tool,'SizeChangedFcn','torre.frontend_folder_tool_current_size = torre_change_size_function(torre.h_frontend_folder_tool,torre.frontend_folder_tool_current_size,torre.frontend_folder_tool_relative_size);');
set(findobj(torre.h_frontend_folder_tool.Children,'-property','FontSize'),'FontSize',torre_fontsize);
torre.h_frontend_selection_tree.Multiselect = 'on';

set(torre.h_frontend_folder_tool,'Position',[768   132   332   338])