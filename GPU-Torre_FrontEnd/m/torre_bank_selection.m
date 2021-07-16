function torre_bank_selection(hObject,eventdata,handles)

items_aux = eventdata.Indices(:,1);
evalin('base', ['torre.bank_items_selected = [' num2str(items_aux(:)') ']'';']);

end