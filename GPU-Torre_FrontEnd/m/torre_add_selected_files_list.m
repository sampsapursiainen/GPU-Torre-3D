for torre_i = 1 : size(torre.h_frontend_selection_tree.SelectedNodes,1)

torre.h_frontend_files_panel.Items{end+1} = torre.h_frontend_selection_tree.SelectedNodes(torre_i).Text;

end

torre.script_pipeline = torre.h_frontend_files_panel.Items;

clear torre_i