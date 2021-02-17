%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [rec_data, t] = frequency2timedomain(f_rec_data, f_min, f_max, pulse_length, carrier_cycles_per_pulse_cycle, scaling_constant, varargin)

unit_scale = 1e-9;

if not(isempty(varargin))
    if not(isempty(varargin{1}))
    unit_scale = varargin{1};
    end
end

mu_0 = 4*pi*1e-7;
eps_0 = 8.85*1e-12;
c_0 = 1/sqrt(mu_0*eps_0);
pulse_length = scaling_constant*pulse_length/(c_0);

f_min = f_min/unit_scale;
f_max = f_max/unit_scale;
f_vec = linspace(f_min,f_max, length(f_rec_data)); 

l_val = 2*length(f_vec)+1; 
dt = 1/(2*(f_vec(end)-f_vec(1)));
t = dt*[0 : l_val-1]'; 
pulse_ind = [0:floor(pulse_length/dt)]';
s = zeros(size(t));
[~,s_0] = bh_window(pulse_ind,pulse_ind(end),carrier_cycles_per_pulse_cycle,'complex');
s(pulse_ind+1) = s_0;

% Use data and simulated pulse to model the measured signal
f_rec_data = f_rec_data(:);
G_vec = [0; f_rec_data(:); flipud(f_rec_data(:))];
rec_data = complex(real(ifft(G_vec.*fft(real(s)))),real(ifft(G_vec.*fft(imag(s)))));


end
