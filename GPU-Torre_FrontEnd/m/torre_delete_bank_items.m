if(questdlg('Delete selected bank items?'))
torre.aux_field = setdiff([1:length(torre.bank_data)]',torre.bank_items_selected);
torre.bank_data = torre.bank_data(torre.aux_field);
torre.h_frontend_bank_panel.Data = torre.h_frontend_bank_panel.Data(torre.aux_field,:);
torre.bank_panel_data = torre.h_frontend_bank_panel.Data;
torre = rmfield(torre,{'aux_field'});
end