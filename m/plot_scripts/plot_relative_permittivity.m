%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

%This script plots the relative permittivity obtained with the script
%volumetric_data_interpolation.m.
%

%********************************************************************
%Set parameters
%********************************************************************
parameters;

%********************************************************************
%Script starts here. 
%********************************************************************

color_mat = [0 1 1; 1 0 1; 0 0 1; 0 1 0];


figure(2); clf; rotate3d('on');

h_slice = slice(x_lattice, y_lattice, z_lattice, real(relative_permittivity_lattice), 0, 0 ,0);
set(h_slice,'edgecolor','none');
c_map = flipud(gray(256));
colormap(c_map); colorbar;
axis equal

camlight right

title('Real relative permittivity')


figure(3); clf; rotate3d('on');

h_slice = slice(x_lattice, y_lattice, z_lattice, imag(relative_permittivity_lattice), 0, 0 ,0);
set(h_slice,'edgecolor','none');
c_map = flipud(gray(256));
colormap(c_map); colorbar;
axis equal

camlight right

title('Imaginary relative permittivity')

