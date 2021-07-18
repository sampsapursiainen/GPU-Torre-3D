torre_data = GPU_Torre_FrontEnd_Bank;
torre.fieldnames_aux = fieldnames(torre_data);
for torre_i = 1 : length(torre.fieldnames_aux)
torre.(torre.fieldnames_aux{torre_i}) = torre_data.(torre.fieldnames_aux{torre_i});
end
torre = rmfield(torre,'fieldnames_aux');

set(torre.h_frontend_apply_bank_panel,'ButtonPushedFcn','torre_apply_bank_panel;');
set(torre.h_frontend_menu_add_parameters_bank_panel,'MenuSelectedFcn','torre.add_bank_item_type = 1; torre_add_bank_item;');
set(torre.h_frontend_menu_add_script_pipeline_bank_panel,'MenuSelectedFcn','torre.add_bank_item_type = 2; torre_add_bank_item;');
set(torre.h_frontend_menu_delete_bank_panel,'MenuSelectedFcn','torre_delete_bank_items;');
set(torre.h_frontend_bank_panel,'CellSelectionCallback', @torre_bank_selection);
set(torre.h_frontend_bank_panel,'columnformat',{torre.bank_item_type_cell,'char'});
set(torre.h_frontend_bank_tool,'Name',[torre.gputorre_name ' Frontend: Bank tool']);

torre_init_bank;

set(torre.h_frontend_bank_tool,'AutoResizeChildren','off');
torre.frontend_bank_tool_current_size = get(torre.h_frontend_bank_tool,'Position');
torre.frontend_bank_tool_relative_size = torre_get_relative_size(torre.h_frontend_bank_tool);
set(torre.h_frontend_bank_tool,'SizeChangedFcn','torre.frontend_bank_tool_current_size = torre_change_size_function(torre.h_frontend_bank_tool,torre.frontend_bank_tool_current_size,torre.frontend_bank_tool_relative_size);');
set(findobj(torre.h_frontend_bank_tool.Children,'-property','FontSize'),'FontSize',torre.fontsize);

 set(torre.h_frontend_bank_tool,'Position',[774   503   331   353]);
