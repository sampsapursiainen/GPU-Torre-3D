function [suggested_number_of_refinements_zero_tolerance, suggested_time_step_zero_tolerance, suggested_number_of_refinements_five_percent_tolerance, suggested_time_step_five_percent_tolerance] =  evaluate_courant_condition(nodes,tetra,p_vec,signal_frequency,courant_number)

tetra_sort = [tetra(:,[1 2]); 
              tetra(:,[2 3]); 
              tetra(:,[3 1]); 
              tetra(:,[1 4]);
              tetra(:,[2 4]);
              tetra(:,[3 4]);              
              ];
                  
p_vec = repmat(p_vec,6,1);

edge_length = sqrt(sum((nodes(tetra_sort(:,2),1:3)-nodes(tetra_sort(:,1),1:3)).^2,2));

aux_vec = edge_length.*sqrt(p_vec);

tetra_sort = sort(tetra_sort,2);
[~, I] = unique(tetra_sort,'rows');

aux_vec = aux_vec(I);

aux_val = max(aux_vec)*(2*signal_frequency);
suggested_number_of_refinements_zero_tolerance = round(log(aux_val)/log(2));
suggested_time_step_zero_tolerance = courant_number*min(aux_vec)/(2^(1+suggested_number_of_refinements_zero_tolerance));
aux_val = quantile(aux_vec*(2*signal_frequency),0.95);
suggested_number_of_refinements_five_percent_tolerance = round(log(aux_val)/log(2))
suggested_time_step_five_percent_tolerance = courant_number*min(aux_vec)/(2^(1+suggested_number_of_refinements_five_percent_tolerance));


end