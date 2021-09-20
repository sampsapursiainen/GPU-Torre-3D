
torre_data = GPU_Torre_FrontEnd;

torre.h_frontend= torre_data.h_frontend;
torre.h_frontend_parameter_table = torre_data.h_frontend_parameter_table;
torre.h_frontend_apply = torre_data.h_frontend_apply;
torre.h_frontend_selection_tree = torre_data.h_frontend_selection_tree;
torre.h_frontend_files_panel = torre_data.h_frontend_files_panel;
torre.h_frontend_add_files_panel = torre_data.h_frontend_add_files_panel;
torre.h_frontend_delete_files_panel = torre_data.h_frontend_delete_files_panel;
torre.h_frontend_move_selected_up_files_panel = torre_data.h_frontend_move_selected_up_files_panel;
torre.h_frontend_run_files_panel = torre_data.h_frontend_run_files_panel;
torre.h_frontend_menu_files_panel = torre_data.h_frontend_menu_files_panel;
torre.h_frontend_menu_add_files_panel = torre_data.h_frontend_menu_add_files_panel;
torre.h_frontend_menu_delete_files_panel = torre_data.h_frontend_menu_delete_files_panel;
torre.h_frontend_menu_move_selected_up_files_panel = torre_data.h_frontend_menu_move_selected_up_files_panel;
torre.h_frontend_menu_run_files_panel = torre_data.h_frontend_menu_run_files_panel;

clear torre_data
torre_data = load('parameters_data.dat');


torre_data.fieldnames = fieldnames(torre_data);
torre.h_frontend_parameter_table.Data= torre_data.fieldnames;

torre_data.parametervalues = struct2cell(torre_data);
for torre_i = 1 : length(torre_data.fieldnames)
    torre.h_frontend_parameter_table.Data{torre_i,2} = torre_data.parametervalues{torre_i};
%     assignin('base', torre_data.fieldnames{torre_i}, torre_data.parametervalues{torre_i});
end
clear torre_data

torre_set_directory_items(torre.h_frontend_selection_tree, dir(torre_dir));
torre.h_frontend_selection_tree.Multiselect = 'on';
torre.h_frontend_files_panel.Items = cell(0);
torre.h_frontend_files_panel.Multiselect = 'on';

set(torre.h_frontend_add_files_panel,'ButtonPushedFcn','torre_add_selected_files_list;');
set(torre.h_frontend_delete_files_panel,'ButtonPushedFcn','torre_delete_selected_files_list;');
set(torre.h_frontend_move_selected_up_files_panel,'ButtonPushedFcn','torre_move_selected_up_files_list;');
set(torre.h_frontend_run_files_panel,'ButtonPushedFcn','torre_run_selected_files_list;');

set(torre.h_frontend_menu_add_files_panel,'MenuSelectedFcn','torre_add_selected_files_list;');
set(torre.h_frontend_menu_delete_files_panel,'MenuSelectedFcn','torre_delete_selected_files_list;');
set(torre.h_frontend_menu_move_selected_up_files_panel,'MenuSelectedFcn','torre_move_selected_up_files_list;');
set(torre.h_frontend_menu_run_files_panel,'MenuSelectedFcn','torre_run_selected_files_list;');



