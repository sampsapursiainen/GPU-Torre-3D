%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


system_setting_index = 1;
parameters;

load([torre_dir '/system_data/if_configuration.mat'])

[source_angle, path_data] = if2gputorre3d(dstruc, [], receiver_angle_difference);
[source_index, source_sub_index] = dense2sparse(source_angle(path_data(:,1),:),min_aperture_angle,n_configurations);
%get_source_index;

source_angle = source_angle(path_data(source_index,:),:);
path_data = path_data(source_index,:);
I = path_data(:);
J = [1:length(I)];
path_data(J) = J;

[source_points, source_orientations] = labsphere2cart(or_radius, source_angle, rotation_angle_z, rotation_angle_y, polarization_angle);

save([torre_dir '/system_data/signal_configuration.mat'], 'source_points', 'source_orientations', 'path_data', 'source_index', 'source_sub_index');