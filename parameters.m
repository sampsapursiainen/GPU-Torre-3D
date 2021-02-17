%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

real_relative_permittivity_bg = 4;
imaginary_relative_permittivity_bg = 0.01;

%Data mode ('measured' or 'simulated')
data_mode = 'measured';

%Signal specifications
pulse_type = 'Blackman-Harris';
near_field = 0;
pulse_length = 0.12;
carrier_cycles_per_pulse_cycle = 3;
carrier_mode = 'complex';

%Signal specifications
n_r = 92;
n_sats = 2;
spatial_scaling_constant = 6.4516e+03;
temporal_scaling_constant = 1e-9;
rotation_angle_z = 180+42;
rotation_angle_y = 0;
polarization_angle = 90;
or_radius = 2.5353;
or_buffer = 0.005;
s_radius = 0.19;
incident_wave_cut_strength = 5;
t_shift = - or_buffer + or_radius - s_radius;

f_min = 2; 
f_max = 18;
receiver_angle_difference = [-12 0];
min_aperture_angle = 60;
n_configurations = 10;

%Domain specifications
t_1 = 1.1;
r_p_m_layer = 1.05;
pml_val = 15;

%Physical constants
eps_0 = 8.8541878e-12;
mu_0 = 4*pi*1e-7;
c_0 = 1/sqrt(eps_0*mu_0);

%Wave propagation visualization parameters
frame_param = 100;
make_video = 0;
c_view_1 = 0;
c_view_2 = 0;
c_rot_1 = 0.25/2.5;
c_rot_2 = 0.25/2.5;

%Inversion parameters
t_data_0 = 0.05;
t_data_1 = 0.50;
data_resample_val = 4;
deconv_reg_param = 1e-3;
n_iter = 10;
std_lhood = 0.01;
alpha = 0.01;
beta = 0.0001;
eps_val_amp = 1e-8;

%Solver specifications
pcg_tol = 1e-5;
pcg_maxit = 1000;
leap_frog_stopping_criterion = 1E5;
fade_out_param = 10;
time_series_count = 1;
compute_in_pieces = 0;
gpu_extended_memory = 3;
num_workers = 10;
parallel_vectors = 50;

%Point cloud file.
point_cloud_file_name = 'P2/ss.002860000.bt';%'P1/shot2-4.txt';%'P2/ss.002860000.bt';
surface_model_file_name = 'itokawa/itokawa_model.m';

%Material relative permittivity value vector (from the sparsest to the densest).
relative_permittivity_vec = [10 9 8 7 6 5 4 3]*complex(1,0.012);  

%Mixture model applied in the permittivity calculation ('Exp' [Default] or 'M-G').
permittivity_mixture_model = 'Exp';
exponential_mixture_parameter = 1/3;

%Maximum point cloud radius for thresholding outliers.
point_cloud_threshold = 0.05;%1;%0.05;

%The resolution of the volumetric lattice (points to each Cartesian
%direction).
lattice_oversampling_rate = 4;

%Scaling to SI-units.
spatial_unit_scale = 1.49597871E11;
mass_unit_scale = 1.9891*1E30;

%Gaussian smoothing of the point cloud distribution (in SI-units).
volumetric_smoothing_size = 0.01;
volumetric_smoothing_std = 1;
volumetric_n_smoothing_iterations = 1;
surface_smoothing_size = 0.01;
surface_smoothing_std = 2;
surface_n_smoothing_iterations = 3;

%Relative boundary buffer zone size to allow smoothing. 
boundary_buffer = 0.2;
model_fitting_scale = 0.7;%0.6;%0.8;

%Surface parameters.
volumetric_density_surface_threshold = [0.1];
volumetric_surface_transparency = 0.2;
particle_surface_transparency = 0.0;

%Maximal number of faces on surface
max_surface_faces = 1000;

%FEM (Gmsh) geometry file name & mesh generation
gmsh_geo_file_name = [torre_dir '/model_data/model.geo'];
gmsh_msh_file_name = [torre_dir '/model_data/model.msh'];
gmsh_surf_file_name = [torre_dir '/model_data/model_surface.stl'];
gmsh_full_file_name = '/usr/bin/gmsh';


if not(exist('system_setting_index'))
system_setting_index = 1;
end

courant_number = 0.10;

if system_setting_index == 1

d_t = 3.1095e-05;
n_mesh_generation_refinement = 2;
n_refinement = 0;

time_oversampling_rate = 4;
folder_ind = 1;

elseif system_setting_index == 2

d_t = 3.1095e-05;
n_mesh_generation_refinement = 2;
n_refinement = 0;

time_oversampling_rate = 4;
folder_ind = 2;

end

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
