%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


data_normalization = 1;
load([torre_dir '/data_1/point_1_data.mat'])
rec_data_1 = rec_data/data_normalization;
load([torre_dir '/data_2/point_1_data.mat'])
rec_data_2 = rec_data/data_normalization;

ind_1 = find(t_data > 0.12,1);
ind_2 = find(t_data > 0.7,1);

transmission_power = 10;
d_ind = 2;

n_lines = 64;
distance_scaling = 1;
data_scaling = 1/35.3216;
antenna_gain = 1.64;
noise_power_1 = 2e-19;
noise_power_2 = 2e-23;
noise_power_3 = 5e-20;
antenna_aperture_1 = (15/2100)^2*0.13;
antenna_aperture_2 = 0.13*15^2;
bandwidth = 2e6;
mu_0 = 4*pi*1e-7;
eps_0 = 8.85e-12;
t_data = 64.5 + (mu_0*eps_0)^(1/2)*2100*t_data*10^6; 

rec_data_1 = (1/distance_scaling^2)*data_scaling*sqrt(antenna_gain)*sqrt(antenna_aperture_1)*rec_data_1;
rec_data_2 = (1/distance_scaling^2)*data_scaling*sqrt(antenna_gain)*sqrt(antenna_aperture_1)*rec_data_2;

noise_std_1 = sqrt(noise_power_1*antenna_aperture_2*bandwidth/transmission_power/n_lines);
noise_std_2 = sqrt(noise_power_2*antenna_aperture_2*bandwidth/transmission_power/n_lines);
noise_std_3 = sqrt(noise_power_3*antenna_aperture_2*bandwidth/transmission_power/n_lines);

noise_1 = db(noise_std_1) 
noise_2 = db(noise_std_2)
noise_3 = db(noise_std_3)

ind_3 = find(t_data > 68);
max_data = max(db(rec_data_2(d_ind,:)))
max_void_data = max(db(rec_data_2(d_ind,ind_3)))

figure(1);clf; set(1,'renderer','painters'); 
h_plot = plot(t_data(ind_1:ind_2), db(rec_data_2(d_ind,ind_1:ind_2)),t_data(ind_1:ind_2),db(noise_std_1)*ones(size(ind_1:ind_2)),t_data(ind_1:ind_2),db(noise_std_2)*ones(size(ind_1:ind_2)),t_data(ind_1:ind_2),db(noise_std_3)*ones(size(ind_1:ind_2)),t_data(ind_1:ind_2),(max_void_data-8)*ones(size(ind_1:ind_2)));
set(h_plot(1),'linewidth',2);
set(h_plot(2),'linewidth',2);
set(h_plot(3),'linewidth',2);
set(h_plot(4),'linewidth',2);
set(h_plot(5),'linewidth',2);
set(h_plot(1),'color',[0 0 0]);
set(h_plot(2),'color',0.6*[1 1 1]);
set(h_plot(3),'color',0.6*[1 1 1]);
set(h_plot(4),'color',0.6*[1 1 1]);
set(h_plot(4),'color',0.6*[1 1 1]);
set(h_plot(3),'linestyle','--');
set(h_plot(4),'linestyle','-.');
set(h_plot(5),'linestyle',':');
set(gca,'linewidth',2);
set(gca,'fontsize',11);
set(gca,'xlim', [t_data(ind_1) t_data(ind_2)]);
set(gca,'ylim',[-190 -110]);
legend({'Signal','Active Sun','Quiet Sun','Galactic noise','Minimum SNR'},'location','northoutside','orientation','horizontal')
pbaspect([2 1 1]); 
hold on; 
h_line = line(66.15*[1 1],[-190 -110]);
set(h_line,'linewidth',2);
set(h_line,'color',[0 0 0]);
set(h_line,'linestyle','--');
h_line = line(67.85*[1 1],[-190 -110]);
set(h_line,'linewidth',2);
set(h_line,'color',[0 0 0]);
set(h_line,'linestyle','--');
h_text = text(66.2,-116,'Surface layer');
set(h_text,'fontsize',11);
h_text = text(67.9,-116,'Void at 150 m depth');
set(h_text,'fontsize',11);
hold off;
figure(2); clf; set(2,'renderer','painters');
h_plot = plot(t_data(ind_1:ind_2), db(rec_data_1(d_ind,ind_1:ind_2)-rec_data_2(1,ind_1:ind_2)),t_data(ind_1:ind_2),db(noise_std_1*ones(size(ind_1:ind_2))),t_data(ind_1:ind_2),db(noise_std_2*ones(size(ind_1:ind_2))),t_data(ind_1:ind_2),db(noise_std_3)*ones(size(ind_1:ind_2)));
set(gca,'xlim', [t_data(ind_1) t_data(ind_2)]);
set(gca,'ylim',[-170 -90]);
set(gca,'ytick',[-160 -140 -120 -100]);
set(h_plot(1),'linewidth',2);
set(h_plot(2),'linewidth',2);
set(h_plot(3),'linewidth',2);
set(h_plot(4),'linewidth',2);
set(h_plot(1),'color',[0 0 0]);
set(h_plot(2),'color',0.6*[1 1 1]);
set(h_plot(3),'color',0.6*[1 1 1]);
set(h_plot(4),'color',0.6*[1 1 1]);
set(h_plot(3),'linestyle','--');
set(h_plot(4),'linestyle','-.');
set(gca,'linewidth',2);
set(gca,'fontsize',11);
set(gca,'xlim', [t_data(ind_1) t_data(ind_2)]);
set(gca,'ylim',[-170 -90]);
set(gca,'ytick',[-160 -140 -120 -100]);
legend({'Signal','Active Sun','Quiet Sun','Galactic noise'},'location','northoutside','orientation','horizontal')
pbaspect([2 1 1]);
hold on;
h_line = line(66.15*[1 1],[-170 -90]);
set(h_line,'linewidth',2);
set(h_line,'color',[0 0 0]);
set(h_line,'linestyle','--');
h_line = line(67.85*[1 1],[-170 -90]);
set(h_line,'linewidth',2);
set(h_line,'color',[0 0 0]);
set(h_line,'linestyle','--');
h_text = text(66.2,-96,'Surface layer');
set(h_text,'fontsize',11);
h_text = text(67.9,-96,'Void at 150 m depth');
set(h_text,'fontsize',11);
hold off;

print(1,'-r300','-dpng','data_link_1.png')
print(2,'-r300','-dpng','data_link_2.png')

