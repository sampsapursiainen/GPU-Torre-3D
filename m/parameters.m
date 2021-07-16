%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

if not(exist('torre'))
torre_data = readcell('parameters_data.dat');
if size(torre_data,2) < 4
      torre_data(:,4) = {''};
end
for torre_i = 1 : size(torre_data,1)
if ismissing(torre_data{torre_i,4})
torre_data{torre_i,4} = '';
end
end
elseif not(isstruct(torre))
torre_data = readcell('parameters_data.dat');
if size(torre_data,4) < 4
      torre_data(:,4) = {''};
end
for torre_i = 1 : size(torre_data,1)
if ismissing(torre_data{torre_i,4})
torre_data{torre_i,4} = '';
end
end
else 
torre_data = torre.parameters_data;
end

for torre_i = 1 : size(torre_data)
    assignin('base',torre_data{torre_i,1},torre_data{torre_i,2})
end

clear torre_data; 

receiver_angle_difference = [receiver_angle_difference_1, receiver_angle_difference_2];
%Material relative permittivity value vector (from the sparsest to the densest).
% relative_permittivity_vec = [10 9 8 7 6 5 4 3]*complex(1,0.012);  

if isequal(pulse_type,'Blackman-Harris')
pulse_window_function = @bh_window;
elseif isequal(pulse_type,'Ricker')
pulse_window_function = @mh_window;
end
t_1 = t_1/time_series_count;
t_vec = [0:d_t:t_1];
[signal_pulse] = pulse_window_function([0:d_t:pulse_length], pulse_length, carrier_cycles_per_pulse_cycle, 'complex');
[signal_center_frequency, signal_bandwidth,signal_highest_frequency] = calc_cf_and_bw([0:d_t:pulse_length], signal_pulse,80);
data_param = floor(1/(d_t*2*signal_highest_frequency*time_oversampling_rate));
