torre.h_frontend_bank_panel.Data = [torre.h_frontend_bank_panel.Data ; {torre.bank_item_type_cell{torre.add_bank_item_type},''}];
torre.bank_panel_data = torre.h_frontend_bank_panel.Data;
if torre.add_bank_item_type == 1
torre.bank_data{end+1} = torre.parameters_data;
elseif torre.add_bank_item_type == 2
torre.bank_data{end+1} = torre.h_frontend_files_panel.Data;
end