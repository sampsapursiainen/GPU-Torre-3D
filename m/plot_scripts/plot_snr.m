%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


system_setting_index = 1;
parameters;

reference_amplitude = 4*pi*or_radius*spatial_scaling_constant^2;
plot_receiver_index = 2;

t_data = t_vec(1:data_param:end);

t_scaled = (t_data + 2*t_shift*spatial_scaling_constant)/c_0;
time_start = (t_data_0 + 2*t_shift*spatial_scaling_constant)/c_0;
time_end = (t_data_1 + 2*t_shift*spatial_scaling_constant)/c_0;

load([torre_dir '/system_data/signal_configuration.mat']);

transmitter_ind = unique(path_data(:,1));
receiver_ind = unique(path_data(:,2:end));
antenna_t_p = source_points(transmitter_ind,:);
antenna_t_o = source_orientations(transmitter_ind,:); 
antenna_r_p = source_points(receiver_ind,:);
antenna_r_o = source_orientations(receiver_ind,:); 

load([torre_dir '/signal_data/measured_data_1.mat']);
load([torre_dir '/signal_data/measured_data_2.mat']);
load([torre_dir '/signal_data/simulated_data_1.mat']);
load([torre_dir '/signal_data/simulated_data_2.mat']);

file_name = [torre_dir '/system_data/itokawa_surface.stl'];


  I_start = find(t_data >= t_data_0,1);
   I_end = find(t_data >= t_data_1,1);
   if isempty(I_end)
       I_end = length(t_data);
   end
  
    target_mesh = stlread(file_name);
    target_mesh_scaled.Points = (or_radius/s_radius)*target_mesh.Points;
     target_mesh_scaled.ConnectivityList = target_mesh.ConnectivityList;
    
    topography_vec_1 = zeros(size(target_mesh_scaled.Points,1),1);
     topography_vec_2 = zeros(size(target_mesh_scaled.Points,1),1);
      normalization_vec_1 = zeros(size(target_mesh_scaled.Points,1),1);
     normalization_vec_2 = zeros(size(target_mesh_scaled.Points,1),1);
     
     difference_vec_1 = zeros(size(path_data,1),1);
     difference_vec_2 = zeros(size(path_data,1),1);
     
    
    for i = 1 : size(path_data,1)
        
    aux_data_1 = interp1(t_measured_1, measured_data_complex_1{i,plot_receiver_index}, t_data,'nearest');
    aux_data_2 = interp1(t_measured_2, measured_data_complex_2{i,plot_receiver_index}, t_data,'nearest');
    
    aux_data_1(find(isnan(aux_data_1))) = 0;
    aux_data_2(find(isnan(aux_data_2))) = 0;
    
    norm_ind = 2;
    difference_vec_1(i) = norm(abs(aux_data_1(I_start:data_resample_val:I_end)) - abs(rec_data_complex_1{i,plot_receiver_index}(I_start:data_resample_val:I_end)),norm_ind)./norm(abs(rec_data_complex_1{i,plot_receiver_index}(I_start:data_resample_val:I_end)),norm_ind); 
    difference_vec_2(i) = norm(abs(aux_data_2(I_start:data_resample_val:I_end)) - abs(rec_data_complex_2{i,plot_receiver_index}(I_start:data_resample_val:I_end)),norm_ind)./norm(abs(rec_data_complex_2{i,plot_receiver_index}(I_start:data_resample_val:I_end)),norm_ind);   
    
    aux_vec = sqrt(sum((target_mesh_scaled.Points - antenna_r_p(i*ones(size(target_mesh_scaled.Points,1),1),:)).^2,2));
    aux_vec = 1./aux_vec;
    topography_vec_1 = topography_vec_1 + (1./difference_vec_1(i)).*aux_vec;
    topography_vec_2 = topography_vec_2 + (1./difference_vec_2(i)).*aux_vec;
    normalization_vec_1 = normalization_vec_1 + aux_vec;
    normalization_vec_2 = normalization_vec_2 + aux_vec;
    end
    
    topography_vec_1 = db_fun(topography_vec_1./normalization_vec_1);
    topography_vec_2 = db_fun(topography_vec_2./normalization_vec_2);
    
    figure(1); clf
    h_surf_1 = trisurf(target_mesh_scaled.ConnectivityList,target_mesh_scaled.Points(:,1),target_mesh_scaled.Points(:,2),target_mesh_scaled.Points(:,3),topography_vec_1);
 set(h_surf_1,'facealpha',1);
    shading interp
   camlight headlight
   camlight right
   colormap jet
   material([0.5 0.3 0.3])
   set(gca,'visible','on')
   axis equal
   hold on;
   h_s =  quiver3(antenna_r_p(:,1),antenna_r_p(:,2),antenna_r_p(:,3),antenna_r_o(:,1),antenna_r_o(:,2),antenna_r_o(:,3),0.25,'ok');
h_s =  quiver3(antenna_t_p(:,1),antenna_t_p(:,2),antenna_t_p(:,3),antenna_t_o(:,1),antenna_t_o(:,2),antenna_t_o(:,3),0.25,'ok--');
set(gca,'fontsize',14)
 title('Homogeneous model SNR')
    [min_val_1,min_ind_1] = min(difference_vec_1);
   [max_val_1,max_ind_1] = max(difference_vec_1);
    h_s = scatter3(antenna_r_p(min_ind_1,1),antenna_r_p(min_ind_1,plot_receiver_index),antenna_r_p(min_ind_1,3),'filled','r');
   set(h_s,'sizedata',48)
      h_s = scatter3(antenna_r_p(max_ind_1,1),antenna_r_p(max_ind_1,plot_receiver_index),antenna_r_p(max_ind_1,3),'filled','b');
   set(h_s,'sizedata',48)
      h_s = scatter3(antenna_t_p(min_ind_1,1),antenna_t_p(min_ind_1,plot_receiver_index),antenna_t_p(min_ind_1,3),'filled','r');
   set(h_s,'sizedata',48)
      h_s = scatter3(antenna_t_p(max_ind_1,1),antenna_t_p(max_ind_1,plot_receiver_index),antenna_t_p(max_ind_1,3),'filled','b');
   set(h_s,'sizedata',48)
   legend('Target','Receiver','Transmitter','Highest SNR','Lowest SNR');
   title('Homogeneous model');
  hold off
   colorbar
   
    figure(2); 
    h_surf_2 = trisurf(target_mesh_scaled.ConnectivityList,target_mesh_scaled.Points(:,1),target_mesh_scaled.Points(:,2),target_mesh_scaled.Points(:,3),topography_vec_2);
 set(h_surf_2,'facealpha',1);
    shading interp
   camlight headlight
   camlight right
   colormap jet
   material([0.5 0.3 0.3])
   set(gca,'visible','on')
   axis equal
    hold on;
   h_s =  quiver3(antenna_r_p(:,1),antenna_r_p(:,2),antenna_r_p(:,3),antenna_r_o(:,1),antenna_r_o(:,2),antenna_r_o(:,3),0.25,'ok');
h_s =  quiver3(antenna_t_p(:,1),antenna_t_p(:,2),antenna_t_p(:,3),antenna_t_o(:,1),antenna_t_o(:,2),antenna_t_o(:,3),0.25,'ok--');
set(gca,'fontsize',14)
title('Detailed model SNR')
    [min_val_2,min_ind_2] = min(difference_vec_2);
   [max_val_2,max_ind_2] = max(difference_vec_2);
     h_s = scatter3(antenna_r_p(min_ind_2,1),antenna_r_p(min_ind_2,plot_receiver_index),antenna_r_p(min_ind_2,3),'filled','r');
   set(h_s,'sizedata',48)
      h_s = scatter3(antenna_r_p(max_ind_2,1),antenna_r_p(max_ind_2,plot_receiver_index),antenna_r_p(max_ind_2,3),'filled','b');
   set(h_s,'sizedata',48)
       h_s = scatter3(antenna_t_p(min_ind_2,1),antenna_t_p(min_ind_2,plot_receiver_index),antenna_t_p(min_ind_2,3),'filled','r');
   set(h_s,'sizedata',48)
      h_s = scatter3(antenna_t_p(max_ind_2,1),antenna_t_p(max_ind_2,plot_receiver_index),antenna_t_p(max_ind_2,3),'filled','b');
   set(h_s,'sizedata',48)
    legend('Target','Receiver','Transmitter','Highest SNR','Lowest SNR');
 title('Detailed model');
    hold off
   colorbar
   
   figure(3); 
   aux_data_1 = interp1(t_measured_1, reference_amplitude*measured_data_complex_1{min_ind_1,plot_receiver_index}, t_data,'nearest');
   h_plot = plot(t_scaled(I_start:data_resample_val:I_end), abs(aux_data_1(I_start:data_resample_val:I_end)), 'k', t_scaled(I_start:data_resample_val:I_end), reference_amplitude*abs(rec_data_complex_1{min_ind_1,plot_receiver_index}(I_start:data_resample_val:I_end)),'r');
   pbaspect([2 1 1])
   title('Homogeneous model amplitude');
   legend('Measured','Simulated','location','southoutside','orientation','horizontal');
   set(h_plot,'linewidth',3)
   set(h_plot(1),'linestyle',':')
   set(gca,'linewidth',1)
   set(gca,'fontsize',14);
   set(gca,'xlim',[time_start time_end]);
   
   figure(4);
   aux_data_1 = interp1(t_measured_1, reference_amplitude*measured_data_complex_1{max_ind_1,plot_receiver_index}, t_data,'nearest');
   h_plot = plot(t_scaled(I_start:data_resample_val:I_end), abs(aux_data_1(I_start:data_resample_val:I_end)), 'k', t_scaled(I_start:data_resample_val:I_end), reference_amplitude*abs(rec_data_complex_1{max_ind_1,plot_receiver_index}(I_start:data_resample_val:I_end)),'b');
   pbaspect([2 1 1])
   title('Homogeneous model amplitude');
   legend('Measured','Simulated','location','southoutside','orientation','horizontal');
   set(h_plot,'linewidth',3)
   set(h_plot(1),'linestyle',':')
   set(gca,'linewidth',1)
   set(gca,'fontsize',14);
   set(gca,'xlim',[time_start time_end]);
   
    figure(5); 
   aux_data_2 = interp1(t_measured_2, reference_amplitude*measured_data_complex_2{min_ind_2,plot_receiver_index}, t_data,'nearest');
   h_plot = plot(t_scaled(I_start:data_resample_val:I_end), abs(aux_data_2(I_start:data_resample_val:I_end)), 'k--', t_scaled(I_start:data_resample_val:I_end), reference_amplitude*abs(rec_data_complex_2{min_ind_2,plot_receiver_index}(I_start:data_resample_val:I_end)),'r');
   pbaspect([2 1 1])
   title('Detailed model amplitude');
   legend('Measured','Simulated','location','southoutside','orientation','horizontal');
   set(h_plot,'linewidth',3)
   set(h_plot(1),'linestyle',':')
   set(gca,'linewidth',1)
   set(gca,'fontsize',14);
   set(gca,'xlim',[time_start time_end]);
   
       figure(6); 
   aux_data_2 = interp1(t_measured_2, reference_amplitude*measured_data_complex_2{max_ind_2,plot_receiver_index}, t_data,'nearest');
   h_plot = plot(t_scaled(I_start:data_resample_val:I_end), abs(aux_data_2(I_start:data_resample_val:I_end)), 'k--', t_scaled(I_start:data_resample_val:I_end), reference_amplitude*abs(rec_data_complex_2{max_ind_2,plot_receiver_index}(I_start:data_resample_val:I_end)),'b');
   pbaspect([2 1 1])
   title('Detailed model amplitude');
   legend('Measured','Simulated','location','southoutside','orientation','horizontal');
   set(h_plot,'linewidth',3)
   set(h_plot(1),'linestyle',':')
   set(gca,'linewidth',1)
   set(gca,'fontsize',14);
   set(gca,'xlim',[time_start time_end]);
  
   figure(7); 
      avg_param =  ceil(2*pulse_length/(t_measured_1(2)-t_measured_1(1)));
   for i = 1 : size(path_data,1)
   max_peak_1 = max(abs(measured_data_complex_1{i,plot_receiver_index}));
   end
   aux_data_1 = interp1(t_measured_1, measured_data_1{min_ind_1,plot_receiver_index}, t_data,'nearest');
  aux_data_2 = interp1(t_measured_1, measured_data_1{max_ind_1,plot_receiver_index}, t_data,'nearest');
     aux_data_1_quad = interp1(t_measured_1, measured_data_quad_1{min_ind_1,plot_receiver_index}, t_data,'nearest');
  aux_data_2_quad = interp1(t_measured_1, measured_data_quad_1{max_ind_1,plot_receiver_index}, t_data,'nearest');
  aux_data_1_0 = complex(aux_data_1,aux_data_1_quad);
   aux_data_2_0 = complex(aux_data_2,aux_data_2_quad);
   rec_data_1_0 = complex(rec_data_1{min_ind_1,plot_receiver_index}, rec_data_quad_1{min_ind_1,plot_receiver_index});
  rec_data_2_0 = complex(rec_data_1{max_ind_1,plot_receiver_index}, rec_data_quad_1{max_ind_1,plot_receiver_index}); 
   snr_vec_1 = db_fun(max_peak_1./(movmean(abs(aux_data_1_0(I_start:data_resample_val:I_end)-rec_data_1_0(I_start:data_resample_val:I_end)),[0 avg_param])));
   snr_vec_2 = db_fun(max_peak_1./(movmean(abs(aux_data_2_0(I_start:data_resample_val:I_end)-rec_data_2_0(I_start:data_resample_val:I_end)),[0 avg_param])));
   h_plot = plot(t_scaled(I_start:data_resample_val:I_end),snr_vec_1,'r',t_scaled(I_start:data_resample_val:I_end),snr_vec_2,'b');
   pbaspect([2 1 1])
   title('Homogeneous model peak SNR');
   set(h_plot,'linewidth',3)
   set(h_plot(1),'linestyle',':')
   set(gca,'linewidth',1)
   set(gca,'fontsize',14);
   set(gca,'xlim',[time_start time_end]);
   set(gca,'ylim',[-10 30])
   h_line = line([time_start time_end], [10 10]);
   set(h_line,'linewidth',1,'linestyle','--','color','k');
    legend('Highest SNR','Lowest SNR','10 dB','location','southoutside','orientation','horizontal');
   hold off;
   
      figure(8); 
   avg_param =  ceil(2*pulse_length/(t_measured_2(2)-t_measured_2(1)));
   for i = 1 : size(path_data,1)
   max_peak_2 = max(abs(measured_data_complex_2{i,plot_receiver_index}));
   end
      aux_data_1 = interp1(t_measured_2, measured_data_2{min_ind_2,plot_receiver_index}, t_data,'nearest');
  aux_data_2 = interp1(t_measured_2, measured_data_2{max_ind_2,plot_receiver_index}, t_data,'nearest');
     aux_data_1_quad = interp1(t_measured_2, measured_data_quad_2{min_ind_2,plot_receiver_index}, t_data,'nearest');
  aux_data_2_quad = interp1(t_measured_2, measured_data_quad_1{max_ind_2,plot_receiver_index}, t_data,'nearest');
  aux_data_1_0 = complex(aux_data_1,aux_data_1_quad);
   aux_data_2_0 = complex(aux_data_2,aux_data_2_quad);
   rec_data_1_0 = complex(rec_data_2{min_ind_2,plot_receiver_index}, rec_data_quad_2{min_ind_2,plot_receiver_index});
  rec_data_2_0 = complex(rec_data_2{max_ind_2,plot_receiver_index}, rec_data_quad_2{max_ind_2,plot_receiver_index});
   snr_vec_1 = db_fun(max_peak_2./(movmean(abs(aux_data_1_0(I_start:data_resample_val:I_end)-rec_data_1_0(I_start:data_resample_val:I_end)),[0 avg_param])));
   snr_vec_2 = db_fun(max_peak_2./(movmean(abs(aux_data_2_0(I_start:data_resample_val:I_end)-rec_data_2_0(I_start:data_resample_val:I_end)),[0 avg_param])));   
   h_plot = plot(t_scaled(I_start:data_resample_val:I_end),snr_vec_1,'r',t_scaled(I_start:data_resample_val:I_end),snr_vec_2,'b');
   pbaspect([2 1 1])
   title('Detailed model peak SNR');
   set(h_plot,'linewidth',3)
   set(h_plot(1),'linestyle',':')
   set(gca,'linewidth',1)
   set(gca,'fontsize',14);
   set(gca,'xlim',[time_start time_end]);
   set(gca,'ylim',[-10 30])
   h_line = line([time_start time_end], [10 10]);
   set(h_line,'linewidth',1,'linestyle','--','color','k');
   legend('Highest SNR','Lowest SNR','10 dB','location','southoutside','orientation','horizontal');
   hold off;
