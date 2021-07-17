function torre_script_pipeline_selection(hObject,eventdata,handles)

items_aux = eventdata.Indices(:,1);
evalin('base', ['torre.scripts_selected = [' num2str(items_aux(:)') ']'';']);

end