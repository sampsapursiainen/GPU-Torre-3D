torre.parameters_data(end+1,:) = {'new_parameter','',torre.parameter_types_cell{1},torre.parameter_methods_cell{1},'Description'};
torre.parameters_visible_index = [torre.parameters_visible_index size(torre.parameters_data,1)];
torre.h_frontend_parameters_panel.Data = torre.parameters_data(torre.parameters_visible_index,:);