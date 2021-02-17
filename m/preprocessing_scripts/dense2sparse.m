%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [sparse_index_2, sub_index] = dense2sparse(angle_vec_t, separation_angle, varargin) 

n_sets = 1;
if not(isempty(varargin))
    n_sets = varargin{1};
end

sparse_index_1 = 1;
[x,y,z] = sph2cart(angle_vec_t(1,2)*pi/180,pi/2-angle_vec_t(1,1)*pi/180,1);
p_vec_1 = [x;y;z];
p_vec_2 = [];

sparse_index_2 = [];
sub_index = [];


for j = 1 : n_sets
    
    sub_index = [sub_index length(sparse_index_2)];
   

    
for i = 1 : size(angle_vec_t,1)

[x,y,z] = sph2cart(angle_vec_t(i,2)*pi/180,pi/2-angle_vec_t(i,1)*pi/180,1);
p_aux = [x;y;z];
if isempty(p_vec_1) 
angle_min_1 = Inf;
else
angle_min_1 = min(acosd(dot(p_aux(:,ones(1,size(p_vec_1,2))),p_vec_1)));
end

if isempty(p_vec_2)
angle_min_2 = Inf;
else
angle_min_2 = min(acosd(dot(p_aux(:,ones(1,size(p_vec_2,2))),p_vec_2)));
end

if angle_min_1 >= separation_angle && angle_min_2 >= separation_angle/sqrt(n_sets)
sparse_index_1 = [sparse_index_1 ; i];
p_vec_1 = [p_vec_1 p_aux];
end

end


for i = 1 : size(angle_vec_t,1)

[x,y,z] = sph2cart(angle_vec_t(i,2)*pi/180,pi/2-angle_vec_t(i,1)*pi/180,1);
p_aux = [x;y;z];
if isempty(p_vec_1) 
angle_min_1 = Inf;
else
angle_min_1 = min(acosd(dot(p_aux(:,ones(1,size(p_vec_1,2))),p_vec_1)));
end


if angle_min_1 >= separation_angle 
sparse_index_1 = [sparse_index_1 ; i];
p_vec_1 = [p_vec_1 p_aux];
end

end


sparse_index_2 = [sparse_index_2 ; sparse_index_1];
p_vec_2 = [p_vec_2 p_vec_1];
p_vec_1 = [];
sparse_index_1 = [];

end

sub_index = [sub_index length(sparse_index_2)];

end