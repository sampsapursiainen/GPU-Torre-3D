%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

parameters;

load([torre_dir '/system_data/mesh_' int2str(system_setting_index) '.mat']) 
interpolation_radius = 1.15*s_radius;
lattice_resolution = round(4*lattice_oversampling_rate*(signal_highest_frequency)*interpolation_radius);
I_aux = find(abs(nodes(:,1))<interpolation_radius & abs(nodes(:,2))<interpolation_radius & abs(nodes(:,3))<interpolation_radius);
interp_ind = zeros(length(I_aux),3);
[x_lattice_interpolation,y_lattice_interpolation,z_lattice_interpolation] = meshgrid([-interpolation_radius + interpolation_radius/(lattice_resolution): 2*interpolation_radius/(lattice_resolution):interpolation_radius-interpolation_radius/(lattice_resolution)]);
interp_ind_aux = griddata(nodes(I_aux,1),nodes(I_aux,2),nodes(I_aux,3),[1:length(I_aux)]',x_lattice_interpolation,y_lattice_interpolation,z_lattice_interpolation,'nearest');
Interp_mat = sparse([1:lattice_resolution^3]',interp_ind_aux(:),ones(lattice_resolution^3,1),lattice_resolution^3,size(nodes,1));

save([torre_dir '/system_data/interp_mat_' int2str(system_setting_index) '.mat'], 'Interp_mat', 'x_lattice_interpolation', 'y_lattice_interpolation', 'z_lattice_interpolation', '-v7.3');