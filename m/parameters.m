%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D
function parameters(varargin)

parameters_size = 5;

if length(varargin) > 1
    torre_data = readcell(varargin{2});
else

if not(evalin('base','exist(''torre'')'))
torre_data = readcell('parameters_data.dat');
if size(torre_data,2) < parameters_size
      torre_data(:,parameters_size) = {''};
end
for torre_i = 1 : size(torre_data,1)
if ismissing(torre_data{torre_i,parameters_size})
torre_data{torre_i,parameters_size} = '';
end
end
elseif not(isstruct(evalin('base','torre')))
torre_data = readcell('parameters_data.dat');
if size(torre_data,parameters_size) < parameters_size
      torre_data(:,parameters_size) = {''};
end
for torre_i = 1 : size(torre_data,1)
if ismissing(torre_data{torre_i,parameters_size})
torre_data{torre_i,parameters_size} = '';
end
end
else 
torre_data = evalin('base', 'torre.parameters_data');
end
end

category_cell = 'All';
if not(isempty(varargin))
    category_cell = varargin{1};
end

if not(isequal(category_cell,'All'))
    category_cell = unique(torre_data(:,3))';
end

for torre_i = 1 : size(torre_data)
    if ismember(torre_data{torre_i,3},category_cell)
        if not(ismember(torre_data{torre_i,4},{'Post evaluate','Expression evaluate'}))
        if isequal(torre_data{torre_i,4},'Assign')
    assignin('base',torre_data{torre_i,1},torre_data{torre_i,2});
        elseif isequal(torre_data{torre_i,4},'Evaluate')
         evalin('base',[ torre_data{torre_i,1} ' = ' torre_data{torre_i,2} ';' ]);       
        end
        end
    end
end

for torre_i = 1 : size(torre_data)
    if ismember(torre_data{torre_i,3},category_cell)
        if isequal(torre_data{torre_i,4},'Post evaluate')
         evalin('base',[torre_data{torre_i,1} ' = ' torre_data{torre_i,2} ';']);             
        end
    end
end

for torre_i = 1 : size(torre_data)
    if ismember(torre_data{torre_i,3},category_cell)
     if isequal(torre_data{torre_i,4},'Expression evaluate')
         evalin('base',[torre_data{torre_i,2} ';']); 
        end
    end
end
         
clear torre_data; 

% assignin(receiver_angle_difference = [receiver_angle_difference_1, receiver_angle_difference_2];
% 
% %Material relative permittivity value vector (from the sparsest to the densest).
% % relative_permittivity_vec = [10 9 8 7 6 5 4 3]*complex(1,0.012);  
% 
% if isequal(pulse_type,'Blackman-Harris')
% pulse_window_function = @bh_window;
% elseif isequal(pulse_type,'Ricker')
% pulse_window_function = @mh_window;
% end
% t_1 = t_1/time_series_count; t_vec = [0:d_t:t_1];
% [signal_pulse] = pulse_window_function([0:d_t:pulse_length], pulse_length, carrier_cycles_per_pulse_cycle, 'complex'); [signal_center_frequency, signal_bandwidth,signal_highest_frequency] = calc_cf_and_bw([0:d_t:pulse_length],signal_pulse,80); data_param = floor(1/(d_t*2*signal_highest_frequency*time_oversampling_rate));

end