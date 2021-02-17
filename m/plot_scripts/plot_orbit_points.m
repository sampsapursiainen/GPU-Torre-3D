%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


load([torre_dir '/system_data/mesh_3D_1.mat'])

system_setting_index = 1;
parameters;

h_surf_ast=trisurf(surface_triangles_ast,nodes(:,1),nodes(:,2),nodes(:,3),ones(size(nodes,1),1));
shading interp
view(0,0)
material([0.3 0.5 0.5])
hold on
[X,Y,Z] = sphere(20);
sphere_radius = 0.007;
axis equal; 
set(gca,'visible','off');

source_points_aux = 0.24*source_points/or_radius;

angle_limit = 11;

data_name = 'data_1';
if angle_limit < 90
I = find(abs(source_points(:,3)) < or_radius*sin(angle_limit*pi/180));
else
I = [1:n_r]';
end

length(I)

for i = 1 : size(I,1)

h_surf = surf(source_points_aux(I(i),1) + sphere_radius*X, source_points_aux(I(i),2) + sphere_radius*Y, source_points_aux(I(i),3) + sphere_radius*Z);
shading interp;
%set(h_surf, 'facecolor', [0.5 0.5 0.5]);

end

camlight right;
camlight headlight;
c_map = ([0 0 1; 0.7 0.7 0.7]);
colormap(c_map);

hold off;
