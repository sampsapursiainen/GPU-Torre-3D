%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


fig = figure(1); clf;

tet_ast_2 = tetrahedra(ast_ind,1:4);

if deep_interior
  ast_deep_ind = find(ismember(tetrahedra(:,5),[deep_interior_ind]));
  tet_ast_2 = [tet_ast_2; tetrahedra(ast_deep_ind, 1:4)];
end

%% Get asteroid outer shell as well
surface_tetra_ind = find(ismember(tetrahedra(:,5),[ast_surface_ind]));
tet_ast_2 = [tet_ast_2; tetrahedra(surface_tetra_ind, 1:4)];

c_tet_2 = (1/4)*(nodes(tet_ast_2(:,1),:) + nodes(tet_ast_2(:,2),:) + nodes(tet_ast_2(:,3),:) + nodes(tet_ast_2(:,4),:));


ind_m = [ 2 4 3 ;
          1 3 4 ;
          1 4 2 ;
          1 2 3 ];


for i = 1 : 3

if i == 1
subplot(1,3,3);  view(-90,0);
I_cut = find(c_tet_2(:,1)>0);
elseif i == 2
subplot(1,3,2);  view(0,0);
I_cut = find(c_tet_2(:,2)>0);
elseif i == 3
subplot(1,3,1);  view(0,-90);
I_cut = find(c_tet_2(:,3)>0);
end

tetra = tet_ast_2(I_cut,:);
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
surface_triangles_ast = tetra(tetra_ind);
I = tetra_sort(I,5);

I2 = surface_triangles_ast';
p_vec_plot = p_vec(ast_ind);
if deep_interior
  p_vec_plot = [p_vec_plot; p_vec(ast_deep_ind)];
end
p_vec_plot = [p_vec_plot; p_vec(surface_tetra_ind)];

I = I_cut(I);
X_data = nodes(:,1);
Y_data = nodes(:,2);
Z_data = nodes(:,3);
hold on;
h_ast = patch(X_data(I2), Y_data(I2), Z_data(I2),p_vec_plot(I));
set(h_ast,'edgecolor','none');
set(gca,'visible','off');
shading flat;
camlight right;
camlight left;
material([0.6 0.2 0.2]);
axis equal;
axis tight;
colorbar horiz;
end

%print(fig,'asteroid_slice', '-dpng')
