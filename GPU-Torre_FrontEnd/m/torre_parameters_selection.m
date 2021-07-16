function torre_parameters_selection(hObject,eventdata,handles)

items_aux = eventdata.Indices(:,1);
evalin('base', ['torre.parameters_selected = [' num2str(items_aux(:)') ']'';']);

end