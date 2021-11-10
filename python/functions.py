# -*- coding: utf-8 -*-
"""
Created on Wed Mar  3 02:41:21 2021

@author: Otto
"""
import numpy as np
from numpy import pi, sqrt, sin, cos
from numpy.fft import fft, ifft

def ind2sub(array_shape, ind):
    rows = (ind.astype('int') // array_shape[1])
    cols = (ind.astype('int') % array_shape[1])
    return (cols.ravel(), rows.ravel())

def if2gputorre3d(dstruc, difcal, receiver_angle_difference):
    dstruc.phis = np.array([dstruc.phis,]*dstruc.phio.shape[0])
    I =  np.argwhere(~np.isnan(dstruc.phio.ravel()))
    J,K = ind2sub(dstruc.phio.shape, I)
    source_angle_t = [dstruc.phis.ravel()[I[:,0]], dstruc.phio.ravel()[I[:,0]]]
    f_rec_data = np.zeros((np.size(I, axis=0)))
    path_data = np.arange(1.,np.size(I, axis=0)+1.)[:, np.newaxis]
    source_angle = np.array(source_angle_t).transpose()
    for i in range (0,receiver_angle_difference.shape[0]):
      path_data = [path_data.ravel(), (i+1)*np.size(I, axis=0)+path_data[:,0]]
      source_angle_mem = []
      for k in range (i,receiver_angle_difference.shape[1]):
          if (k != 0):
              source_angle_mem =  np.vstack((source_angle_mem,source_angle_t[k] + receiver_angle_difference[0][k])).transpose()
          else:
              source_angle_mem =  source_angle_t[k] + receiver_angle_difference[0][k]
      source_angle = np.vstack((source_angle, source_angle_mem))   
      if (~np.all(difcal==0)):
          f_rec_data_mem = np.empty((np.size(I, axis=0)),dtype=object)
          for j in range (0,np.size(I, axis=0)):
              f_rec_data_mem[j] = difcal[:,K[j],i,J[j]]
          f_rec_data = np.vstack((f_rec_data, f_rec_data_mem))
    return (source_angle, np.array(path_data).transpose(), f_rec_data.transpose())

def frequency2timedomain(f_rec_data, f_min, f_max, pulse_length, carrier_freq, scaling_constant, unit_scale = 1e-9):
    mu_0 = 4*pi*1e-7
    eps_0 = 8.8541878e-12
    c_0 = 1 / sqrt(mu_0 * eps_0)
    pulse_length = scaling_constant * pulse_length / (c_0)
    f_min = f_min / unit_scale
    f_max = f_max / unit_scale
    f_vec = np.linspace(f_min, f_max, f_rec_data.shape[0])
    l_val = 2 * f_vec.shape[0] + 1
    dt = 1 / (2 * (f_vec[-1] - f_vec[0]))
    t = dt * np.arange(0, l_val, dtype = "complex").transpose()
    pulse_ind = np.arange(0, np.floor(pulse_length/dt) + 1).transpose()
    s = np.zeros(t.shape, dtype="complex")
    _, s_0 = bh_window(pulse_ind, pulse_ind[-1], carrier_freq, "complex")
    for i in range(0,pulse_ind.shape[0]):
        s[i] = s_0[i]
    
    f_rec_data = f_rec_data.flatten()
    G_vec = np.concatenate((0,f_rec_data), axis=None)
    G_vec = np.concatenate((G_vec, np.flipud(f_rec_data)), axis=None)
    re = (ifft(G_vec * fft((s).real))).real
    im = (ifft(G_vec * fft((s).imag))).real
    rec_data = np.vectorize(complex)(re, im)
    return (rec_data, t)

def bh_window(t, T, carrier_freq, carrier_mode):
    ones_vec = np.ones(t.shape)
    T_ind = (t>T).nonzero()
    ones_vec[T_ind] = 0
    T_ind = (t<0).nonzero()
    ones_vec[T_ind] = 0
    
    a_0 = 0.35875
    a_1 = 0.48829
    a_2 = 0.14128
    a_3 = 0.01168
    if (carrier_freq == 0):
        bh_vec_cos = (2*pi/T)*(a_0 - a_1*cos(2*pi*t/T) + a_2*cos(4*pi*t/T) - a_3*cos(6*pi*t/T))
        bh_vec_sin = np.zeros(bh_vec_cos.shape)
        d_bh_vec_cos = ((2*a_1*pi*sin((2*pi*t)/T))/T - (4*a_2*pi*sin((4*pi*t)/T))/T + (6*a_3*pi*sin((6*pi*t)/T))/T)
        d_bh_vec_sin = bh_vec_cos
    else:
       bh_vec_sin = (a_0 - a_1*cos(2*pi*t/T) + a_2*cos(4*pi*t/T) - a_3*cos(6*pi*t/T))*sin(carrier_freq*2*pi*t/T)
       d_bh_vec_sin = sin((2*pi*carrier_freq*t)/T)*((2*a_1*pi*sin((2*pi*t)/T))/T - (4*a_2*pi*sin((4*pi*t)/T))/T + (6*a_3*pi*sin((6*pi*t)/T))/T) + (2*carrier_freq*pi*cos((2*pi*carrier_freq*t)/T)*(a_0 - a_1*cos((2*pi*t)/T) + a_2*cos((4*pi*t)/T) - a_3*cos((6*pi*t)/T)))/T
       bh_vec_cos = (a_0 - a_1*cos(2*pi*t/T) + a_2*cos(4*pi*t/T) - a_3*cos(6*pi*t/T))*cos(carrier_freq*2*pi*t/T)
       d_bh_vec_cos = cos((2*pi*carrier_freq*t)/T)*((2*a_1*pi*sin((2*pi*t)/T))/T - (4*a_2*pi*sin((4*pi*t)/T))/T + (6*a_3*pi*sin((6*pi*t)/T))/T) - (2*carrier_freq*pi*sin((2*pi*carrier_freq*t)/T)*(a_0 - a_1*cos((2*pi*t)/T) + a_2*cos((4*pi*t)/T) - a_3*cos((6*pi*t)/T)))/T 
    if (carrier_freq == 0):
        amplitude_scale = 2*pi/T
    else:
        amplitude_scale = 2*pi*carrier_freq/T
        
    if (carrier_mode == "complex"):
         bh_vec = np.vectorize(complex)(bh_vec_cos, bh_vec_sin)/amplitude_scale
         d_bh_vec = np.vectorize(complex)(d_bh_vec_cos, d_bh_vec_sin)/amplitude_scale
    elif (carrier_mode == "cos"):
         bh_vec = bh_vec_cos/amplitude_scale
         d_bh_vec = d_bh_vec_cos/amplitude_scale
    elif (carrier_mode == "sin"):
         bh_vec = bh_vec_sin/amplitude_scale
         d_bh_vec = d_bh_vec_sin/amplitude_scale
         
    bh_vec = bh_vec*ones_vec
    d_bh_vec = d_bh_vec*ones_vec

    return(bh_vec, d_bh_vec)
    
def qam_demod(wave_val, carrier_freq, pulse_length, t_data):
    equalize_components = 1
    if (carrier_freq > 0):
        qam_resolution = 360
        step =  pi / 2 / qam_resolution
        stop = (pi / 2) - (pi / 2 / qam_resolution)
        phase_angle = np.arange(0, stop + step, step, dtype="complex")
        max_data_val = np.zeros((qam_resolution, 1), dtype = "complex")  
        for i in range (0,phase_angle.shape[0]):
            aa = 2*pi*carrier_freq*t_data/pulse_length + phase_angle[i]
            carrier_1 = cos(2*pi*carrier_freq*t_data/pulse_length + phase_angle[i])
            carrier_2 = sin(2*pi*carrier_freq*t_data/pulse_length+phase_angle[i])    
            data_val = (wave_val).real * carrier_1 + (wave_val).imag * carrier_2
            max_data_val[i] = np.amax(abs(data_val))
        phase_angle_ind = np.argmax(max_data_val)
        phase_angle = phase_angle[phase_angle_ind] - pi/2
        
        carrier_1 = cos(2 * pi * carrier_freq *t_data / pulse_length + phase_angle)
        carrier_2 = sin(2 * pi * carrier_freq * t_data / pulse_length + phase_angle) 
        data_val_inphase = (wave_val).real * carrier_1 + (wave_val).imag * carrier_2

        carrier_1 = cos( 2 * pi * carrier_freq * t_data / pulse_length + phase_angle + pi / 2)
        carrier_2 = sin( 2 * pi * carrier_freq * t_data / pulse_length + phase_angle + pi / 2)
        data_val_quad = (wave_val).real * carrier_1 + (wave_val).imag * carrier_2

        #amp_val ei näytä tarkkoja arvoja
        amp_val = sqrt( (wave_val).real ** 2 + (wave_val).imag ** 2)
        scale_array = np.kron( np.ones((1, data_val.shape[0])), amp_val.max(0) / (sqrt(data_val_inphase ** 2 + data_val_quad ** 2)).max(0) )
        data_val_inphase = equalize_components * scale_array * data_val_inphase
        data_val_quad = scale_array * data_val_quad
        
    else:
        data_val_inphase = (wave_val).real
        data_val_quad = (wave_val).imag
        amp_val = sqrt( data_val_inphase ** 2 + data_val_quad ** 2)
        
    return(data_val_inphase, data_val_quad, amp_val)