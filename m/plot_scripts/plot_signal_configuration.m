%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


system_setting_index = 1;
parameters;

load([torre_dir '/system_data/signal_configuration.mat']);

transmitter_ind = unique(path_data(:,1));
receiver_ind = unique(path_data(:,2:end));
antenna_t_p = source_points(transmitter_ind,:);
antenna_t_o = source_orientations(transmitter_ind,:); 
antenna_r_p = source_points(receiver_ind,:);
antenna_r_o = source_orientations(receiver_ind,:); 

file_name = gmsh_surf_file_name;
  
    target_mesh = stlread(file_name);
    target_mesh_scaled.Points = (or_radius/s_radius)*target_mesh.Points;
     target_mesh_scaled.ConnectivityList = target_mesh.ConnectivityList;
    
    figure(1); clf
    h_surf_1 = trisurf(target_mesh_scaled.ConnectivityList,target_mesh_scaled.Points(:,1),target_mesh_scaled.Points(:,2),target_mesh_scaled.Points(:,3),ones(size(target_mesh_scaled.Points,1),1));
 set(h_surf_1,'facealpha',1);
    shading interp
   camlight headlight
   camlight right
   colormap jet
   material([0.5 0.3 0.3])
   set(gca,'visible','off')
   axis equal
   hold on;
   
   c_map = lines(length(source_sub_index)-1);
 for i = 1 : length(source_sub_index)-1
 I = [source_sub_index(i)+1:source_sub_index(i+1)];
 h_s_1{i} =  quiver3(antenna_r_p(I,1),antenna_r_p(I,2),antenna_r_p(I,3),antenna_r_o(I,1),antenna_r_o(I,2),antenna_r_o(I,3),0.25,'ok');
 h_s_1{i}.Color = c_map(i,:);
h_s_2{i} =  quiver3(antenna_t_p(I,1),antenna_t_p(I,2),antenna_t_p(I,3),antenna_t_o(I,1),antenna_t_o(I,2),antenna_t_o(I,3),0.25,'ok--');
  h_s_2{i}.Color = c_map(i,:);
 end
legend('Target','Receiver','Transmitter'); 
set(gca,'fontsize',14)
 title('Signal configuration')
  hold off
  