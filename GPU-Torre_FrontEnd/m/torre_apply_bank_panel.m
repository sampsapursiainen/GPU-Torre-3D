if(questdlg('Apply selected bank items?'))
for torre_i = 1 : length(torre.bank_items_selected)
   if isequal(torre.h_frontend_bank_panel.Data{torre.bank_items_selected(torre_i),1},torre.bank_item_type_cell{1})
torre.parameters_data = torre.bank_data{torre.bank_items_selected(torre_i)};
torre.h_frontend_parameters_panel.Data = torre.parameters_data;
torre.parameters_visible_index = [1:size(torre.parameters_data,1)];
parameters;
elseif isequal(torre.h_frontend_bank_panel.Data{torre.bank_items_selected(torre_i),1},torre.bank_item_type_cell{2})
torre.h_frontend_files_panel.Data = torre.bank_data{torre.bank_items_selected(torre_i)};
torre.script_pipeline = torre.h_frontend_files_panel.Data;
   end
end
end