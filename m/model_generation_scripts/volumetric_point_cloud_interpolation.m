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
%point_cloud : the original point cloud of N points (Nx3 matrix)
%unique_particle_density_vec : the vector of unique particle densities
%unique_color_vec : the vector of unique particle colors
%with indices corresponding to the STL surface indices.
%radius_vec : point radii in the point cloud
%density_vec : point density in the point cloud
%mass_vec : point mass in the point cloud 
%color_vec : particle color in the point cloud 
%lattice_resolution : resolution of the volumetric lattice
%lattice_size_x : voxel size in x-direction
%lattice_size_y : voxel size in y-direction
%lattice_size_z : voxel size in z-direction
%unit_scaling_constant : unit scaling constant
%The parameters of the script are set in the parameter section below.
%
%********************************************************************
%Set parameters
%********************************************************************
parameters;

%********************************************************************
%Script starts here. 
%********************************************************************

point_cloud = load([torre_dir '/model_data/' point_cloud_file_name]);

center_of_mass = sum(repmat(point_cloud(:,3),1,3).*point_cloud(:,[5 6 7]))/sum(point_cloud(:,3)); 

point_cloud_distance_aux = sqrt(sum((point_cloud(:, [5 6 7]) - repmat(center_of_mass, size(point_cloud,1),1)).^2,2));
I = find(point_cloud_distance_aux <= point_cloud_threshold*max(point_cloud_distance_aux));
point_cloud = point_cloud(I,:);

unit_scaling_constant = spatial_unit_scale*max((max(point_cloud(:,[5 6 7])) - min(point_cloud(:,[5 6 7]))))/(2*s_radius*model_fitting_scale);

color_vec = point_cloud(:,14);
mass_vec = mass_unit_scale*point_cloud(:,3);
radius_vec = spatial_unit_scale*point_cloud(:,4);
density_vec = mass_vec./((4/3)*pi*radius_vec.^3);
point_cloud = (1/unit_scaling_constant)*spatial_unit_scale*point_cloud(:,[5 6 7]);
[unique_color_vec, ind_aux] = sort(unique(color_vec));

unique_color_vec = [unique_color_vec density_vec(ind_aux)];

unique_particle_density_vec = sort(unique(density_vec));

center_of_mass = sum(repmat(mass_vec,1,3).*point_cloud)/sum(mass_vec); 
point_cloud = point_cloud - repmat(center_of_mass, size(point_cloud,1),1);

min_x = (1 + boundary_buffer)*min(point_cloud(:,1));
max_x = (1 + boundary_buffer)*max(point_cloud(:,1));
min_y = (1 + boundary_buffer)*min(point_cloud(:,2));
max_y = (1 + boundary_buffer)*max(point_cloud(:,2));
min_z = (1 + boundary_buffer)*min(point_cloud(:,3));
max_z = (1 + boundary_buffer)*max(point_cloud(:,3));

lattice_resolution = round(2*lattice_oversampling_rate*(signal_highest_frequency)*max([(max_x - min_x) (max_y - min_y) (max_z - min_z)]));

lattice_size_x = (max_x - min_x)/(lattice_resolution);
lattice_size_y = (max_y - min_y)/(lattice_resolution);
lattice_size_z = (max_z - min_z)/(lattice_resolution);

volumetric_smoothing_size_vec = round(0.5*(volumetric_smoothing_size./[lattice_size_x lattice_size_y lattice_size_z]- 1));
volumetric_smoothing_size_vec = 2*volumetric_smoothing_size_vec + 1;

[x_lattice,y_lattice,z_lattice] = meshgrid([min_x+lattice_size_x/2:lattice_size_x:max_x-lattice_size_x/2],[min_y+lattice_size_y/2:lattice_size_y:max_y-lattice_size_y/2],[min_z+lattice_size_z/2:lattice_size_z:max_z-lattice_size_z/2]);

volumetric_density_lattice = zeros(size(x_lattice));

filling_lattice = cell(0);
for i = 1 : size(unique_color_vec,1)
filling_lattice{i} = zeros(size(volumetric_density_lattice));
end

lattice_point_cloud = [x_lattice(:) y_lattice(:) z_lattice(:)];

start_time = now;

lattice_size_vec = [lattice_size_x lattice_size_y lattice_size_z];   
lattice_min_vec = [min(x_lattice(:)) min(y_lattice(:)) min(z_lattice(:))];

volumetric_density_lattice = volumetric_density_lattice(:);

for i = 1 : size(unique_color_vec,1)
    
filling_lattice{i} = filling_lattice{i}(:);
    
material_type_ind = find(color_vec == unique_color_vec(i));
point_cloud_ind = zeros(length(material_type_ind),3); 

for j = 1 : 3
point_cloud_ind(:,j) = max(1,min(lattice_resolution, round((point_cloud(material_type_ind,j) - lattice_min_vec(j))/lattice_size_vec(j))+1));
end
 
point_cloud_ind = point_cloud_ind(:,2)  + lattice_resolution*(point_cloud_ind(:,1)-1) + lattice_resolution^2*(point_cloud_ind(:,3)-1);


volumetric_density_lattice = volumetric_density_lattice + accumarray(point_cloud_ind, density_vec(i)*ones(length(point_cloud_ind),1),[length(volumetric_density_lattice) 1]);

filling_lattice{i} = filling_lattice{i} + accumarray(point_cloud_ind, ones(length(point_cloud_ind),1),[length(filling_lattice{i}) 1]);
filling_lattice{i} = reshape(filling_lattice{i}, lattice_resolution*[1 1 1]);


end

volumetric_density_lattice = reshape(volumetric_density_lattice, lattice_resolution*[1 1 1]);

for smoothing_iteration_ind = 1 : volumetric_n_smoothing_iterations
volumetric_density_lattice = smooth3(volumetric_density_lattice,'gaussian', volumetric_smoothing_size_vec,volumetric_smoothing_std);
end

volumetric_density_lattice(find(isnan(volumetric_density_lattice(:)))) = 0;
density_scaling = sum(mass_vec)./(sum(volumetric_density_lattice(:)*lattice_size_x*lattice_size_y*lattice_size_z)*unit_scaling_constant^3);
volumetric_density_lattice = density_scaling*volumetric_density_lattice;


for i = 1 : length(filling_lattice)
for smoothing_iteration_ind = 1 : volumetric_n_smoothing_iterations
filling_lattice{i} = smooth3(filling_lattice{i},'gaussian', volumetric_smoothing_size_vec,volumetric_smoothing_std);
end
filling_lattice{i} = density_scaling*filling_lattice{i};
end
    

calculate_relative_permittivity;

volumetric_data.x_lattice = x_lattice;
volumetric_data.y_lattice = y_lattice;
volumetric_data.z_lattice = z_lattice;
volumetric_data.volumetric_density_lattice = volumetric_density_lattice;
volumetric_data.filling_lattice = filling_lattice;
volumetric_data.relative_permittivity_lattice = relative_permittivity_lattice;
volumetric_data.point_cloud = point_cloud;
volumetric_data.unique_particle_density_vec = unique_particle_density_vec;
volumetric_data.radius_vec = radius_vec;
volumetric_data.density_vec = density_vec;
volumetric_data.mass_vec = mass_vec;
volumetric_data.lattice_resolution = lattice_resolution;
volumetric_data.lattice_size_x = lattice_size_x;
volumetric_data.lattice_size_y = lattice_size_y;
volumetric_data.lattice_size_z = lattice_size_z;
volumetric_data.unit_scaling_constant = unit_scaling_constant;
volumetric_data.color_vec = color_vec;
volumetric_data.unique_color_vec = unique_color_vec;

save([torre_dir '/model_data/volumetric_data.mat'],  'volumetric_data');

plot_volumetric_data;

stl_data = reducepatch(patch_data, min(1, max_surface_faces/size(patch_data.Faces,1)));
surface_triangulation = triangulation(stl_data.faces,stl_data.vertices);
stlwrite(surface_triangulation,gmsh_surf_file_name);

plot_relative_permittivity;





