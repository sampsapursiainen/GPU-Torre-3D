%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


n_sub_index = 20;
sub_index_length = 20;

source_sub_index = zeros(sub_index_length, n_sub_index);

for i =  1 : n_sub_index
   
aux_vec = randperm(size(J_mat,1));    
aux_vec = aux_vec(:);
source_sub_index(:,i) = aux_vec(1:sub_index_length);
    
end