%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [antenna_points, antenna_orientations] = labsphere2cart(or_radius, angle_vec, rotation_angle_z, rotation_angle_y, polarization_angle, varargin)

translation_vec = [0;0;0];
if not(isempty(varargin)) > 0
    translation_vec = varargin{1};
    translation_vec = translation_vec(:);
end

aux_fiis = angle_vec(:,1);
aux_fiio = angle_vec(:,2);

x = or_radius.*sind(aux_fiis(:)).*cosd(aux_fiio(:));
y = or_radius.*sind(aux_fiis(:)).*sind(aux_fiio(:));
z = or_radius.*cosd(aux_fiis(:));

x_o_x = -sind(aux_fiio(:));
y_o_x = cosd(aux_fiio(:));
z_o_x = zeros(size(x_o_x));

x_o_y = cosd(aux_fiis(:)).*cosd(aux_fiio(:));
y_o_y = cosd(aux_fiis(:)).*sind(aux_fiio(:));
z_o_y = -sind(aux_fiis(:));

x_o = cosd(polarization_angle)*x_o_x + sind(polarization_angle)*x_o_y; 
y_o = cosd(polarization_angle)*y_o_x + sind(polarization_angle)*y_o_y; 
z_o = cosd(polarization_angle)*z_o_x + sind(polarization_angle)*z_o_y; 

if not(isempty(rotation_angle_z))
RotZ = [cosd(rotation_angle_z) -sind(rotation_angle_z) 0; sind(rotation_angle_z) cosd(rotation_angle_z) 0; 0 0 1];
aux_vec = RotZ*[x'; y'; z'];
x = aux_vec(1,:)';
y = aux_vec(2,:)';
z = aux_vec(3,:)';
aux_vec = RotZ*[x_o'; y_o'; z_o'];
x_o = aux_vec(1,:)';
y_o = aux_vec(2,:)';
z_o = aux_vec(3,:)';
end

if not(isempty(rotation_angle_y))
RotY = [cosd(rotation_angle_y) 0 sind(rotation_angle_y); 0 1 0; -sind(rotation_angle_y) 0 cosd(rotation_angle_y)];
aux_vec = RotY*[x'; y'; z'];
x = aux_vec(1,:)';
y = aux_vec(2,:)';
z = aux_vec(3,:)';
aux_vec = RotY*[x_o'; y_o'; z_o'];
x_o = aux_vec(1,:)';
y_o = aux_vec(2,:)';
z_o = aux_vec(3,:)';
end

r_vec = [x y z]+translation_vec(ones(size(x,1),1),:);
o_vec = [x_o y_o z_o]+translation_vec(ones(size(x,1),1),:);

antenna_points = r_vec;
antenna_orientations = o_vec(1:end,:);

end
