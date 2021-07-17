torre.parameters_visible_index_aux_1 = strfind(torre.parameters_data(:,[1 3 4]), torre.h_frontend_find_string_parameters_panel.Value);
if not(isequal(torre.h_frontend_find_category.Value,'All'))
torre.parameters_visible_index_aux_2 = strfind(torre.parameters_data(:,3),torre.h_frontend_find_category.Value);  
end
torre.parameters_visible_index = zeros(size(torre.parameters_data,1),1);
for torre_i = 1 : size(torre.parameters_data,1)
        if not(isempty(torre.h_frontend_find_string_parameters_panel.Value))
for torre_j = 1 : size(torre.parameters_visible_index_aux_1,2)
    if not(isempty(torre.parameters_visible_index_aux_1{torre_i,torre_j}))
    torre.parameters_visible_index(torre_i) = 1;
    end
end
        else 
 torre.parameters_visible_index(torre_i) = 1;   
        end 
        
    if not(isequal(torre.h_frontend_find_category.Value,'All'))
    if isempty(torre.parameters_visible_index_aux_2{torre_i,1})
    torre.parameters_visible_index(torre_i) = 0;
    end
    end

end
torre.parameters_visible_index = find(torre.parameters_visible_index);
torre.parameters_visible_index = torre.parameters_visible_index(:)';
torre = rmfield(torre,{'parameters_visible_index_aux_1','parameters_visible_index_aux_1'});
torre.h_frontend_parameters_panel.Data = torre.parameters_data(torre.parameters_visible_index,:);
