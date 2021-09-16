parameters;

path_data = [1 1];
source_index = [1];
source_orientations = [1 0 -1]/sqrt(3);
source_points = or_radius*[1 1 1]/sqrt(3);
source_sub_index = [0 1];
save system_data/signal_configuration.mat path_data source_index source_orientations source_points source_sub_index;
