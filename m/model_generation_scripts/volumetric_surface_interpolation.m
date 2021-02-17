%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

%This scripts creates a volumetric data set from a point cloud model. 
%The  MAT-file containing volumetric data together with a set of STL-files 
%containing isosurfaces of equally dense particles and different thresholds 
%of the volumetric density surface will be written in the working directory. 
%The volumetric data is stored in struct volumetric_data which includes the 
%following fields:
%x_lattice : x-points of the volumetric lattice
%y_lattice : y-points of the volumetric lattice
%z_lattice : z-points of the volumetric lattice
%volumetric_density_lattice : lattice data of the volumetric density
%filling_lattice : lattice data for the relative filling
%relative_permittivity_lattice : lattice data for the relative permittivity
%surface_model_points : the original point cloud of N points (Nx3 matrix)
%unique_particle_density_vec : the vector of unique particle densities
%with indices corresponding to the STL surface indices.
%radius_vec : point radii in the point cloud
%density_vec : point density in the point cloud
%mass_vec : pont mass in the point cloud 
%lattice_resolution : resolution of the volumetric lattice
%lattice_size_x : voxel size in x-direction
%lattice_size_y : voxel size in y-direction
%lattice_size_z : voxel size in z-direction
%
%The parameters of the script are set in the parameter section below.
%
%********************************************************************
%Set parameters
%********************************************************************
parameters;

%********************************************************************
%Script starts here. 
%********************************************************************

run([torre_dir '/model_data/' surface_model_file_name]);


surface_model_points = [];
surface_model_stl = cell(0);
for i = 1 : length(surface_model_stl_file)
surface_model_stl{i} = stlread([surface_model_directory '/' surface_model_stl_file{i}]);
surface_model_points = [surface_model_points ; surface_model_stl{i}.Points];
end
surface_triangulation = triangulation(surface_model_stl{i}.ConnectivityList,surface_model_stl{i}.Points);
stlwrite(surface_triangulation,[torre_dir '/model_data/model_surface.stl']);
unit_scaling_constant = max((max(surface_model_stl{i}.Points) - min(surface_model_stl{i}.Points)))/(2*s_radius*model_fitting_scale);
center_of_mass = mean(surface_model_stl{i}.Points);

surface_model_points = unit_scaling_constant*(surface_model_points - repmat(center_of_mass,size(surface_model_points,1),1));

min_x = (1 + boundary_buffer)*min(surface_model_points(:,1));
max_x = (1 + boundary_buffer)*max(surface_model_points(:,1));
min_y = (1 + boundary_buffer)*min(surface_model_points(:,2));
max_y = (1 + boundary_buffer)*max(surface_model_points(:,2));
min_z = (1 + boundary_buffer)*min(surface_model_points(:,3));
max_z = (1 + boundary_buffer)*max(surface_model_points(:,3));

lattice_resolution = round(2*lattice_oversampling_rate*(signal_highest_frequency)*max([(max_x - min_x) (max_y - min_y) (max_z - min_z)]));

lattice_size_x = (max_x - min_x)/(lattice_resolution);
lattice_size_y = (max_y - min_y)/(lattice_resolution);
lattice_size_z = (max_z - min_z)/(lattice_resolution);

[x_lattice,y_lattice,z_lattice] = meshgrid([min_x+lattice_size_x/2:lattice_size_x:max_x-lattice_size_x/2],[min_y+lattice_size_y/2:lattice_size_y:max_y-lattice_size_y/2],[min_z+lattice_size_z/2:lattice_size_z:max_z-lattice_size_z/2]);

relative_permittivity_lattice = ones(size(x_lattice));

lattice_surface_model_points = [x_lattice(:) y_lattice(:) z_lattice(:)];

h_waitbar = waitbar(0,'Interpolating particles.');

start_time = now;

J = [1:size(lattice_surface_model_points)]';

for i = 1 : length(surface_model_stl)
    
[I] = tetra_in_compartment(surface_model_stl{i}.Points,surface_model_stl{i}.ConnectivityList,lattice_surface_model_points(J,:),[i length(surface_model_stl)]);
relative_permittivity_lattice(J(I)) = surface_model_relative_permittivity(i); 
J = setdiff(J,J(I));

end

close(h_waitbar)

volumetric_data.x_lattice = x_lattice;
volumetric_data.y_lattice = y_lattice;
volumetric_data.z_lattice = z_lattice;
volumetric_data.relative_permittivity_lattice = relative_permittivity_lattice;
volumetric_data.lattice_resolution = lattice_resolution;
volumetric_data.lattice_size_x = lattice_size_x;
volumetric_data.lattice_size_y = lattice_size_y;
volumetric_data.lattice_size_z = lattice_size_z;
volumetric_data.unit_scaling_constant = unit_scaling_constant;
save([torre_dir '/model_data/volumetric_data.mat'],  'volumetric_data');


plot_relative_permittivity;

