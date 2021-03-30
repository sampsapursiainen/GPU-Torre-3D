# -*- coding: utf-8 -*-
"""
Created on Mon Feb 22 15:29:56 2021

@author: Otto
"""
import numpy as np
import h5py

class data ():
    class signal_configuration:
        path_data: []
        source_index: []
        source_orientations: []
        source_points : []
    
    class if_configuration:
        phir: float
        phis: []
        phio: []
        freq: []
        
    class if_data_1:
        difcal: []
        
    class variables:
        '''
        Below needed variables:
        mu_0: float
        eps_0: float
        c_0: float
        f_min: float
        f_max: float
        pulse_length: float
        carrier_freq: float
        spatial_scaling_constant: float
        temporal_scaling_constant: float
        or_radius: float
        or_buffer: float
        s_radius: float
        t_shift: float
        reference_amplitude: float
        time_series_count: float
        t_1: float
        '''
        
        
    
def read_data():   
    datafile = h5py.File('signal_configuration.mat','r')
    data.signal_configuration.path_data = datafile['path_data'][()]
    data.signal_configuration.source_index = datafile['source_index'][()].ravel()
    #source_index is matlab indexes which starts from 1 so to get python index you need to subtract every index value by 1
    data.signal_configuration.source_index = data.signal_configuration.source_index - 1
    data.signal_configuration.source_orientations = datafile['source_orientations'][()]
    data.signal_configuration.source_points = datafile['source_points'][()].ravel()
        
    datafile = h5py.File('if_configuration.mat','r')
    dstruc = datafile['dstruc']
    data.if_configuration.phir = dstruc['phir'][0,0]
    data.if_configuration.phis = dstruc['phis'][()].ravel()
    data.if_configuration.phio = dstruc['phio'][()]
    data.if_configuration.freq = dstruc['freq'][()].ravel()
        
    datafile = h5py.File('if_data_1.mat','r')
    #size (321,90,1,33) in python. size (33,1,90,321) in matlab
    #also datatype of the difcal from matlab is tuple: dtype([('real', '<f8'), ('imag', '<f8')])
    difcal_array =  datafile['difcal'][()]
    p,m,n,r = difcal_array.shape
    data.if_data_1.difcal = np.zeros((p,m,n,r), dtype="complex")
    for i in range (0, p):
        for j in range (0, m):
            for k in range (0, n):
                for l in range (0, r):
                    re = difcal_array[i,j,k,l]['real']
                    im = difcal_array[i,j,k,l]['imag']
                    data.if_data_1.difcal[i,j,k,l] = complex(re, im)
                    
    datafile = h5py.File('variables.mat','r')
    variable_list = list(datafile.keys())
    for var in variable_list:
        setattr(data.variables, var,  datafile[var][0,0])
    return data()