%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D
 
%This script loads the volumetric data created by the script
%volumetric_data_interpolation.m 
%********************************************************************
%Set parameters
%********************************************************************
parameters;

%********************************************************************
%Script starts here. 
%********************************************************************
load([torre_dir '/model_data/volumetric_data.mat']);

if isfield(volumetric_data,'x_lattice')
x_lattice = volumetric_data.x_lattice;
end
if isfield(volumetric_data,'y_lattice')
y_lattice = volumetric_data.y_lattice;
end
if isfield(volumetric_data,'z_lattice')
z_lattice = volumetric_data.z_lattice;
end
if isfield(volumetric_data,'volumetric_density_lattice')
volumetric_density_lattice = volumetric_data.volumetric_density_lattice;
end
if isfield(volumetric_data,'filling_lattice')
filling_lattice = volumetric_data.filling_lattice;
end
if isfield(volumetric_data,'relative_permittivity_lattice')
relative_permittivity_lattice = volumetric_data.relative_permittivity_lattice;
end
if isfield(volumetric_data,'point_cloud')
point_cloud = volumetric_data.point_cloud;
end
if isfield(volumetric_data,'unique_particle_density_vec')
unique_particle_density_vec = volumetric_data.unique_particle_density_vec;
end
if isfield(volumetric_data,'radius_vec')
radius_vec = volumetric_data.radius_vec;
end
if isfield(volumetric_data,'density_vec')
density_vec = volumetric_data.density_vec;
end
if isfield(volumetric_data,'mass_vec')
mass_vec = volumetric_data.mass_vec;
end
if isfield(volumetric_data,'lattice_resolution')
lattice_resolution = volumetric_data.lattice_resolution;
end
if isfield(volumetric_data,'lattice_size_x')
lattice_size_x = volumetric_data.lattice_size_x;
end
if isfield(volumetric_data,'lattice_size_y')
lattice_size_y = volumetric_data.lattice_size_y;
end
if isfield(volumetric_data,'lattice_size_z')
lattice_size_z = volumetric_data.lattice_size_z;
end
if isfield(volumetric_data,'unit_scaling_constant')
unit_scaling_constant = volumetric_data.unit_scaling_constant;
end
if isfield(volumetric_data,'color_vec')
color_vec = volumetric_data.color_vec;
end
if isfield(volumetric_data,'unique_color_vec')
unique_color_vec = volumetric_data.unique_color_vec;
end