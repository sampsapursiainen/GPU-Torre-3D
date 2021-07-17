for torre_i = 1 : size(torre.h_frontend_selection_tree.SelectedNodes,1)

torre.h_frontend_files_panel.Data = [torre.h_frontend_files_panel.Data ; {torre.h_frontend_selection_tree.SelectedNodes(torre_i).Text,'',''}];

end

torre.script_pipeline = torre.h_frontend_files_panel.Data;

clear torre_i