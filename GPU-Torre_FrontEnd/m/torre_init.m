torre_data.file = [];
torre_data.file_path = [];
torre_data.fontsize = 8;
torre_data.frontend_dir = [fileparts(which('gputorre_frontend_start')) '/'];
torre_data.save_file = 'default_project.mat';
torre_data.save_file_path = [torre_data.frontend_dir 'data/'];
torre_data.bank_data = cell(0);
torre_data.bank_panel_data = cell(0);
torre_data.script_pipeline = cell(0);
torre_data.parameter_types_cell = {'General', 'Forward', 'Inverse','Signal','Preprocessing','Postprocessing','Visualization','Model creation','Physics','System', 'Other'};
torre_data.bank_item_type_cell = {'Parameters', 'Script pipeline'};

