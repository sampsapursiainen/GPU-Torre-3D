%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


system_setting_index = 1;
parameters;

mu_0 = 4*pi*1e-7;
eps_0 = 8.85*1e-12;
c_0 = 1/sqrt(mu_0*eps_0);
reference_amplitude = 4*pi*or_radius*spatial_scaling_constant^2;

load([torre_dir '/system_data/if_configuration.mat'])
load([torre_dir '/signal_data/if_data_1.mat'])
load([torre_dir '/system_data/signal_configuration.mat']) 

t_data = t_vec(1:data_param:end);

f_rec_data = cell(0);

[~,~,f_rec_data_aux] = if2gputorre3d(dstruc, difcal, receiver_angle_difference);
for i = 1 : length(source_index)
    for j = 2 : size(f_rec_data_aux,2)
f_rec_data{i,j} = f_rec_data_aux{source_index(i),j};
    end
end

measured_data_1 = cell(0);
measured_data_quad_1 = cell(0);
measured_data_complex_1 = cell(0);

for i = 1 : size(f_rec_data,1)
    for j = 2 : size(f_rec_data,2) 

if i == 1 && j == 2
[aux_vec, t_measured_1] = frequency2timedomain(f_rec_data{i,j}, f_min, f_max, pulse_length, carrier_cycles_per_pulse_cycle, spatial_scaling_constant, temporal_scaling_constant);
t_measured_1 = t_measured_1*c_0 - 2*t_shift*spatial_scaling_constant;
I_start = find(t_measured_1 >= 0,1);
I_end = find(t_measured_1 >= t_1,1);
else
[aux_vec] = frequency2timedomain(f_rec_data{i,j}, f_min, f_max, pulse_length, carrier_cycles_per_pulse_cycle, spatial_scaling_constant, temporal_scaling_constant);
end

[measured_data_1{i,j},measured_data_quad_1{i,j}] = qam_demod(aux_vec,carrier_cycles_per_pulse_cycle,pulse_length,t_measured_1);

measured_data_1{i,j} = measured_data_1{i,j}(I_start:I_end)/reference_amplitude;
measured_data_quad_1{i,j} = measured_data_quad_1{i,j}(I_start:I_end)/reference_amplitude;
measured_data_complex_1{i,j} = aux_vec(I_start:I_end)/reference_amplitude;



    end
end

t_measured_1 = t_measured_1(I_start:I_end);

system_setting_index = 2;
parameters;

load([torre_dir '/signal_data/if_data_2.mat']);

f_rec_data = cell(0);

[~,~,f_rec_data_aux] = if2gputorre3d(dstruc, difcal, receiver_angle_difference);
for i = 1 : length(source_index)
    for j = 2 : size(f_rec_data_aux,2)
f_rec_data{i,j} = f_rec_data_aux{source_index(i),j};
    end
end

measured_data_2 = cell(0);
measured_data_quad_2 = cell(0);
measured_data_complex_2 = cell(0);

for i = 1 : size(f_rec_data,1)
    for j = 2 : size(f_rec_data,2) 

        if i == 1 && j == 2
[aux_vec, t_measured_2] = frequency2timedomain(f_rec_data{i,j}, f_min, f_max, pulse_length, carrier_cycles_per_pulse_cycle, spatial_scaling_constant, temporal_scaling_constant);
t_measured_2 = t_measured_2*c_0 - 2*t_shift*spatial_scaling_constant;
I_start = find(t_measured_2 >= 0,1);
I_end = find(t_measured_2 >= t_1,1);
t_measured_2 = t_measured_2(I_start:I_end);
else
[aux_vec] = frequency2timedomain(f_rec_data{i,j}, f_min, f_max, pulse_length, carrier_cycles_per_pulse_cycle, spatial_scaling_constant, temporal_scaling_constant);
end
        
measured_data_complex_2{i,j} = aux_vec(I_start:I_end)/reference_amplitude;

[measured_data_2{i,j},measured_data_quad_2{i,j}] = qam_demod(measured_data_complex_2{i,j},carrier_cycles_per_pulse_cycle,pulse_length,t_measured_2);

end
end

save([torre_dir '/signal_data/measured_data_1.mat'], 'measured_data_1', 'measured_data_quad_1', 'measured_data_complex_1', 't_measured_1', '-v7.3');
save([torre_dir '/signal_data/measured_data_2.mat'], 'measured_data_2', 'measured_data_quad_2', 'measured_data_complex_2', 't_measured_2', '-v7.3');
