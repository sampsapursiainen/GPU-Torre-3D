%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

parameters;

if system_setting_index == 1
loop_constant = 2;
else
    loop_constant = 1;
end

gpu_id = 1;
carrier_mode = 'complex';

batch_handle_1 = cell(0);

for process_id = 1:loop_constant*n_r

batch_handle_1{process_id} = batch(csc_job,['gputorre3d_init; ' 'process_id = ' int2str(process_id) '; carrier_mode = ''' carrier_mode '''; gpu_id = ' int2str(gpu_id) '; compute_data_1;'],'CurrentFolder','/projappl/project_2002680/gputorre3d','AutoAddClientPath',false);

end
