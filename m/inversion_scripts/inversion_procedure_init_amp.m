%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

load([torre_dir '/system_data/mesh_1.mat']);
load([torre_dir '/system_data/system_data_1.mat']);

load([torre_dir '/system_data/born_approximation_amp.mat']);
load([torre_dir '/system_data/difference_data_amp.mat']);

load([torre_dir '/system_data/signal_configuration.mat']);

system_setting_index = 1;
run([torre_dir '/parameters.m']);

%create_random_sub_index;

if size(source_sub_index,1) == 1
n_k_iter = size(source_sub_index,2) - 1;
else
n_k_iter = size(source_sub_index,2);
end

L = cell(0);
y = cell(0);

for k = 1 : n_k_iter

if size(source_sub_index,1) == 1 
    aux_index_set =  [source_sub_index(k)+1: source_sub_index(k+1)]';
else
    aux_index_set = source_sub_index(:,k);
end
    
L{k} = reshape(J_mat(aux_index_set, :, :), length(aux_index_set)*size(J_mat,2), size(J_mat,3));

y{k} = reshape(difference_data_mat(aux_index_set, :, :), length(aux_index_set)*size(difference_data_mat,2),1);

end

system_setting_index = 1;
run([torre_dir '/parameters.m'])

t_data = t_vec(1:data_param:end);
t_data_resample = t_data(1:data_resample_val:end);
ind_data_0 = find(t_data >= t_data_0,1);
ind_data_1 = find(t_data >= t_data_1,1);
n_t_data = ind_data_1 - ind_data_0 + 1;  
t_data_resample = t_data(ind_data_0:data_resample_val:ind_data_1);
n_jacobian = length(t_data_resample);

data_ind_aux = 0;



Aux_mat = [nodes_ast(tetra_ast(:,1),:)'; nodes_ast(tetra_ast(:,2),:)'; nodes_ast(tetra_ast(:,3),:)'] - repmat(nodes_ast(tetra_ast(:,4),:)',3,1);
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
tilavuus = abs(Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
                - Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
                + Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;

ind_m = [ 2 4 3 ;
           1 3 4 ;
           1 4 2 ; 
           1 2 3 ]; 

tetra_sort = [tetra_ast(:,[2 4 3]) ones(size(tetra_ast,1),1) [1:size(tetra_ast,1)]'; 
              tetra_ast(:,[1 3 4]) 2*ones(size(tetra_ast,1),1) [1:size(tetra_ast,1)]'; 
              tetra_ast(:,[1 4 2]) 3*ones(size(tetra_ast,1),1) [1:size(tetra_ast,1)]'; 
              tetra_ast(:,[1 2 3]) 4*ones(size(tetra_ast,1),1) [1:size(tetra_ast,1)]';];
tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
tetra_sort = sortrows(tetra_sort,[1 2 3]);
tetra_ind = zeros(size(tetra_sort,1),1);
I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);
tetra_ind(I) = 1;
I = find(tetra_ind == 1);
tetra_ind = sub2ind(size(tetra_ast),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
faces_ast = [tetra_ast(tetra_ind) tetra_sort(I,5) tetra_sort(I+1,5)];

aux_vec_1 = nodes_ast(faces_ast(:,2),:) - nodes_ast(faces_ast(:,1),:); 
aux_vec_2 = nodes_ast(faces_ast(:,3),:) - nodes_ast(faces_ast(:,1),:); 
n_vec_aux = cross(aux_vec_1', aux_vec_2')';
ala_vec = sqrt(sum(n_vec_aux.^2,2))/2;

TV_D = sparse(size(tetra_ast,1), size(tetra_ast,1)); 
TV_D = TV_D + sparse(faces_ast(:,4), faces_ast(:,4),ala_vec,size(TV_D,1),size(TV_D,2));
TV_D = TV_D + sparse(faces_ast(:,5), faces_ast(:,5),ala_vec,size(TV_D,1),size(TV_D,2));    
TV_D = TV_D - sparse(faces_ast(:,5), faces_ast(:,4),ala_vec,size(TV_D,1),size(TV_D,2));    
TV_D = TV_D - sparse(faces_ast(:,4), faces_ast(:,5),ala_vec,size(TV_D,1),size(TV_D,2));    
TV_D = TV_D/max(ala_vec);






