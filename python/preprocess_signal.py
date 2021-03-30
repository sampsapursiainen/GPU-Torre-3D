# -*- coding: utf-8 -*-
"""
Created on Wed Mar  3 01:51:10 2021

@author: Otto
"""
import numpy as np
import scipy
import h5py
import hdf5storage
from numpy import pi, sqrt
from load import read_data
from functions import if2gputorre3d, frequency2timedomain, qam_demod

data = read_data()
f_min = data.variables.f_min
f_max = data.variables.f_max
pulse_length = data.variables.pulse_length
carrier_freq = data.variables.carrier_freq 
spatial_scaling_constant = data.variables.spatial_scaling_constant 
temporal_scaling_constant = data.variables.temporal_scaling_constant
mu_0 = data.variables.mu_0
eps_0 = data.variables.eps_0
c_0 = data.variables.c_0
or_radius = data.variables.or_radius
or_buffer = data.variables.or_buffer
s_radius = data.variables.s_radius
t_shift = data.variables.t_shift
reference_amplitude = data.variables.reference_amplitude
time_series_count = data.variables.time_series_count
t_1 = data.variables.t_1





receiver_angle_difference = np.array([[-12, 0]])
_, _, f_rec_data_aux = if2gputorre3d(data.if_configuration, data.if_data_1.difcal, receiver_angle_difference)
source_index = data.signal_configuration.source_index
f_rec_data = np.empty(shape=(data.signal_configuration.source_index.shape[0],f_rec_data_aux.shape[1]),dtype=object)
for i in range (0, source_index.shape[0]):
    for j in range (1, f_rec_data_aux.shape[1]):
        f_rec_data[i,j] = f_rec_data_aux[int(source_index[i]), j]

measured_data_1 = np.zeros(shape=(f_rec_data.shape[0], f_rec_data.shape[1]), dtype=object)
measured_data_quad_1 = np.zeros(shape=(f_rec_data.shape[0], f_rec_data.shape[1]), dtype=object)
measured_data_complex_1 = np.zeros(shape=(f_rec_data.shape[0], f_rec_data.shape[1]), dtype=object)

for i in range (0,  f_rec_data.shape[0]):
    for j in range (1, f_rec_data.shape[1]):
        if((i == 0) and (j == 1)):
            aux_vec, t_measured_1 = frequency2timedomain(f_rec_data[i,j], f_min, f_max, pulse_length, carrier_freq, spatial_scaling_constant, temporal_scaling_constant)
            t_measured_1 = t_measured_1 * c_0 - 2 * t_shift * spatial_scaling_constant
            I_start = np.nonzero(t_measured_1 >= 0)[0]
            I_end = np.nonzero(t_measured_1 >= t_1)[0]
            indexes = list(range(I_start[0],I_end[0]+1))
        else:
            aux_vec, _ = frequency2timedomain(f_rec_data[i,j], f_min, f_max, pulse_length, carrier_freq, spatial_scaling_constant, temporal_scaling_constant)
        measured_data_1[i,j], measured_data_quad_1[i,j], _ = qam_demod(aux_vec, carrier_freq, pulse_length, t_measured_1)
        measured_data_1[i,j] = measured_data_1[i,j].ravel()[indexes]  / reference_amplitude
        measured_data_quad_1[i,j] = measured_data_quad_1[i,j].ravel()[indexes] / reference_amplitude
        measured_data_complex_1[i,j] = aux_vec[indexes] / reference_amplitude
        
t_measured_1 = t_measured_1[indexes]
t_measured_1 = t_measured_1.astype(float)
matcontent = {}
matcontent[u't_measured_1'] = t_measured_1
hdf5storage.write(matcontent, '.', 't_measured_1.mat', matlab_compatible=True)
