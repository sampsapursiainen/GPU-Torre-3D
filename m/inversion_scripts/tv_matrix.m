%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

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
TV_D = TV_D + sparse(faces_ast(:,5), faces_ast(:,5),ala_vec,size(TV_D,1),size(TV_D,2));    
TV_D = TV_D - sparse(faces_ast(:,5), faces_ast(:,4),ala_vec,size(TV_D,1),size(TV_D,2));    
TV_D = TV_D - sparse(faces_ast(:,4), faces_ast(:,5),ala_vec,size(TV_D,1),size(TV_D,2));    


