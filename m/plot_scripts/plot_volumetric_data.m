%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D
 
%This script plots the volumetric data obtained with the script
%volumetric_data_interpolation.m. The plots will be written in the 
%data folder.

%********************************************************************
%Set parameters
%********************************************************************
parameters;

%********************************************************************
%Script starts here. 
%********************************************************************

i = 0;
color_mat = colormap('lines');

figure(1); clf; rotate3d('on');

h_slice = slice(x_lattice, y_lattice, z_lattice, volumetric_density_lattice, 0, 0 ,0);
set(h_slice,'edgecolor','none');
c_map = flipud(gray(256));
colormap(c_map); colorbar;
axis equal
camlight right
title('Volumetric density')

hold on;

i = 0;

for i = 1 : size(unique_color_vec,1)
I = find(color_vec==unique_color_vec(i));
particle_cloud_shape = alphaShape(point_cloud(I,:));
patch_data = plot(particle_cloud_shape);
set(patch_data,'FaceColor',color_mat(mod(i-1,size(color_mat,1))+1,:),'EdgeColor','none','facelighting','phong','diffusestrength',0.5,'specularstrength',0.5,'facealpha',particle_surface_transparency);
end

surface_smoothing_size_vec = round(0.5*(surface_smoothing_size./[lattice_size_x lattice_size_y lattice_size_z]- 1));
surface_smoothing_size_vec = 2*surface_smoothing_size_vec + 1;


surface_lattice = volumetric_density_lattice;
for smoothing_iteration_ind = 1 : surface_n_smoothing_iterations
surface_lattice = smooth3(surface_lattice,'gaussian', surface_smoothing_size_vec,surface_smoothing_std);
end

surface_lattice(find(isnan(surface_lattice(:)))) = 0;
surface_density_scaling = sum(mass_vec)./(sum(surface_lattice(:)*lattice_size_x*lattice_size_y*lattice_size_z)*unit_scaling_constant^3);
surface_lattice = surface_density_scaling*surface_lattice;

clear surface_density_scaling;

for k = 1 : length(volumetric_density_surface_threshold)

i = i + 1;
    
patch_val = volumetric_density_surface_threshold(k)*max(surface_lattice(:));
patch_data = patch(isosurface(x_lattice,y_lattice,z_lattice,surface_lattice,patch_val));
isonormals(x_lattice,y_lattice,z_lattice,surface_lattice,patch_data);
set(patch_data,'FaceColor',color_mat(mod(i-1,size(color_mat,1))+1,:),'EdgeColor','none','facelighting','phong','diffusestrength',0.5,'specularstrength',0.5,'facealpha',volumetric_surface_transparency);

end

clear surface_lattice;

hold off;

set(gca,'visible','off');
