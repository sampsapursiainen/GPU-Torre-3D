%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


system_setting_index = 1;
parameters;

t_data = t_vec(1:data_param:end);

J = find(t_data <= pulse_length);
scaling_vec = ones(1,length(t_data));
scaling_vec(J) = exp(incident_wave_cut_strength*(1-(t_data(J(end)))./abs(t_data(J))));

load([torre_dir '/system_data/signal_configuration.mat'])

rec_data_1 = cell(0);
rec_data_quad_1 = cell(0);
rec_data_complex_1 = cell(0);

for i = 1 : size(path_data,1)

load([torre_dir '/data_1/point_' int2str(path_data(i,1)) '_data.mat'], 'rec_data', 'rec_data_quad', 'rec_data_complex');

for j = 2 : size(path_data,2)

rec_data_1{i,j} = rec_data(path_data(i,j),:).*scaling_vec;
rec_data_quad_1{i,j} = rec_data_quad(path_data(i,j),:).*scaling_vec;
rec_data_complex_1{i,j} = rec_data_complex(path_data(i,j),:).*scaling_vec;

end
end

system_setting_index = 2;
parameters;

t_data = t_vec(1:data_param:end);

J = find(t_data <= pulse_length);
scaling_vec = ones(1,length(t_data));
scaling_vec(J) = exp(incident_wave_cut_strength*(1-(t_data(J(end)))./abs(t_data(J))));

load([torre_dir '/system_data/signal_configuration.mat'])

rec_data_2 = cell(0);
rec_data_quad_2 = cell(0);
rec_data_complex_2 = cell(0);

for i = 1 : size(path_data,1)

load([torre_dir '/data_2/point_' int2str(path_data(i,1)) '_data.mat'], 'rec_data', 'rec_data_quad', 'rec_data_complex');

for j = 2 : size(path_data,2)

rec_data_2{i,j} = rec_data(path_data(i,j),:).*scaling_vec;
rec_data_quad_2{i,j} = rec_data_quad(path_data(i,j),:).*scaling_vec;
rec_data_complex_2{i,j} = rec_data_complex(path_data(i,j),:).*scaling_vec;

end
end

save([torre_dir '/signal_data/simulated_data_1.mat'], 'rec_data_1', 'rec_data_quad_1', 'rec_data_complex_1', '-v7.3');
save([torre_dir '/signal_data/simulated_data_2.mat'], 'rec_data_2', 'rec_data_quad_2', 'rec_data_complex_2', '-v7.3');
