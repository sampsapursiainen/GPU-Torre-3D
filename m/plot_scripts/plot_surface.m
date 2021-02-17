%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [surface_triangles, ind_vec] = plot_surface(nodes, tetra)

tetra = tetra(:,1:4);

 ind_m = [ 2 4 3 ;
           1 3 4 ;
           1 4 2 ; 
           1 2 3 ]; 

I_xyz = find(min(nodes')' <= 0 &  max(abs(nodes)')' <= 0.27 ); 
I_xyz = find(sum(ismember(tetra,I_xyz),2)==4);

I_z = find(nodes(:,3) <= 0); 
I_z = find(sum(ismember(tetra,I_z),2)==4);

I_y = find(nodes(:,2) <= 0); 
I_y = find(sum(ismember(tetra,I_y),2)==4);

I_x = find(nodes(:,1) <= 0); 
I_x = find(sum(ismember(tetra,I_x),2)==4);

tetra_aux = tetra; 

tetra = tetra_aux(I_xyz,:);
tetra_sort = [tetra(:,[2 4 3]) ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 3 4]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 4 2]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 2 3]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]';];
tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
tetra_sort = sortrows(tetra_sort,[1 2 3]);
tetra_ind = zeros(size(tetra_sort,1),1);
I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);
tetra_ind(I) = 1;
tetra_ind(I+1) = 1;
I = find(tetra_ind == 0);
tetra_ind = sub2ind(size(tetra),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
surface_triangles_xyz = tetra(tetra_ind);
ind_vec_xyz = I_xyz(tetra_sort(I,5));


tetra = tetra_aux(I_z,:);
tetra_sort = [tetra(:,[2 4 3]) ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 3 4]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 4 2]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 2 3]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]';];       
tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
[tetra_sort] = sortrows(tetra_sort,[1 2 3]);
tetra_ind = zeros(size(tetra_sort,1),1);
I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);
tetra_ind(I) = 1;
tetra_ind(I+1) = 1;
I = find(tetra_ind == 0);
tetra_ind = sub2ind(size(tetra),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
surface_triangles_z = tetra(tetra_ind);
ind_vec_z = I_z(tetra_sort(I,5));

surf_dir = cross(nodes(surface_triangles_z(:,3),:)' - nodes(surface_triangles_z(:,1),:)', nodes(surface_triangles_z(:,2),:)' - nodes(surface_triangles_z(:,1),:)');
surf_dir = surf_dir./repmat(sqrt(sum(surf_dir.^2)),3,1);
I = find(abs(surf_dir(3,:)) > 0.001);
I = intersect(I,find(nodes(surface_triangles_z(:,3),3) > -0.5));

surface_triangles_z = surface_triangles_z(I,:);
ind_vec_z = ind_vec_z(I);
aux_vec = unique(surface_triangles_z);
I_aux = find(max(abs(nodes(aux_vec,:))')<0.27);
aux_vec = aux_vec(I_aux);
warning off; surface_triangles_z = aux_vec(delaunay(nodes(aux_vec,[1 2]))); warning on;


tetra = tetra_aux(I_y,:);
tetra_sort = [tetra(:,[2 4 3]) ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 3 4]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 4 2]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 2 3]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]';];
tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
tetra_sort = sortrows(tetra_sort,[1 2 3]);
tetra_ind = zeros(size(tetra_sort,1),1);
I = find(sum(abs(tetra_sort(2:end,1:3)-tetra_sort(1:end-1,1:3)),2)==0);
tetra_ind(I) = 1;
tetra_ind(I+1) = 1;
I = find(tetra_ind == 0);
tetra_ind = sub2ind(size(tetra),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
surface_triangles_y = tetra(tetra_ind);
ind_vec_y = I_y(tetra_sort(I,5));

surf_dir = cross(nodes(surface_triangles_y(:,3),:)' - nodes(surface_triangles_y(:,1),:)', nodes(surface_triangles_y(:,2),:)' - nodes(surface_triangles_y(:,1),:)');
surf_dir = surf_dir./repmat(sqrt(sum(surf_dir.^2)),3,1);
I = find(abs(surf_dir(2,:)) > 0.001);
I = intersect(I,find(nodes(surface_triangles_y(:,2),2) > -0.5));

surface_triangles_y = surface_triangles_y(I,:);
ind_vec_y = ind_vec_y(I);
aux_vec = unique(surface_triangles_y);
I_aux = find(max(abs(nodes(aux_vec,:))')<0.27);
aux_vec = aux_vec(I_aux);
warning off; surface_triangles_y = aux_vec(delaunay(nodes(aux_vec,[1 3]))); warning on;


tetra = tetra_aux(I_x,:);
tetra_sort = [tetra(:,[2 4 3]) ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 3 4]) 2*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 4 2]) 3*ones(size(tetra,1),1) [1:size(tetra,1)]'; 
              tetra(:,[1 2 3]) 4*ones(size(tetra,1),1) [1:size(tetra,1)]';];
tetra_sort(:,1:3) = sort(tetra_sort(:,1:3),2);
tetra_sort = sortrows(tetra_sort,[1 2 3]);
tetra_ind = zeros(size(tetra_sort,1),1);
I = find(sum(abs(tetra_sort(2:end,1:3) - tetra_sort(1:end-1,1:3)),2)==0);
tetra_ind(I) = 1;
tetra_ind(I+1) = 1;
I = find(tetra_ind == 0);
tetra_ind = sub2ind(size(tetra),repmat(tetra_sort(I,5),1,3),ind_m(tetra_sort(I,4),:));
surface_triangles_x = tetra(tetra_ind);
ind_vec_x = I_x(tetra_sort(I,5));

surf_dir = cross(nodes(surface_triangles_x(:,3),:)' - nodes(surface_triangles_x(:,1),:)', nodes(surface_triangles_x(:,2),:)' - nodes(surface_triangles_x(:,1),:)');
surf_dir = surf_dir./repmat(sqrt(sum(surf_dir.^2)),3,1);
I = find(abs(surf_dir(1,:)) > 0.001);
I = intersect(I,find(nodes(surface_triangles_x(:,1),1) > -0.5));

surface_triangles_x = surface_triangles_x(I,:);
ind_vec_x = ind_vec_x(I);
aux_vec = unique(surface_triangles_x);
I_aux = find(max(abs(nodes(aux_vec,:))')<0.27);
aux_vec = aux_vec(I_aux);
warning off; surface_triangles_x = aux_vec(delaunay(nodes(aux_vec,[2 3]))); warning on;


surface_triangles = {surface_triangles_x,surface_triangles_y,surface_triangles_z,surface_triangles_xyz};

ind_vec = {ind_vec_x,ind_vec_y,ind_vec_z,ind_vec_xyz};

