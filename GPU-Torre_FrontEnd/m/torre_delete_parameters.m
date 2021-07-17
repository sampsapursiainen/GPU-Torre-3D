if(questdlg('Delete selected parameters?'))
torre.aux_ind_1 = setdiff([1:size(torre.parameters_data,1)],torre.parameters_visible_index(torre.parameters_selected));
torre.aux_ind_2 = zeros(size(torre.parameters_data,1),1);
torre.aux_ind_2(torre.aux_ind_1) = [1:length(torre.aux_ind_1)]';
torre.aux_ind_3 = intersect(torre.parameters_visible_index,torre.aux_ind_1);
torre.parameters_visible_index = torre.aux_ind_2(torre.aux_ind_3);
torre.parameters_visible_index = torre.parameters_visible_index(:)';
torre.parameters_data = torre.parameters_data(torre.aux_ind_1,:); 
torre.h_frontend_parameters_panel.Data = torre.parameters_data(torre.parameters_visible_index,:);
torre = rmfield(torre,{'aux_ind_1','aux_ind_2','aux_ind_3'});
end