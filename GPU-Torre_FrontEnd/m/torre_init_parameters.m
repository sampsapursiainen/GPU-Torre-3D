torre.h_frontend_parameters_panel.Data = torre.parameters_data;
torre.parameters_visible_index = [1:size(torre.parameters_data,1)];
if isfield(torre,'find_category')
torre.h_frontend_find_category.Value = torre.find_category;
end
parameters;

