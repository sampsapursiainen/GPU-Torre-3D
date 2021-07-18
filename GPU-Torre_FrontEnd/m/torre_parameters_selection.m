function torre_parameters_selection(hObject,eventdata,handles)
items_aux = eventdata.Indices(:,1);
evalin('base',['torre.parameters_selected = [' num2str(items_aux(:)') ']'';']);
evalin('base',['torre.h_frontend_description.Value = torre.h_frontend_parameters_panel.Data(torre.parameters_selected(1),end);']);
end