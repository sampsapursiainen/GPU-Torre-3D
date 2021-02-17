%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


load([torre_dir '/system_data/mesh_1.mat']);

figure(1); clf;

thresh_val = 20;

tet_ast_2 = tetrahedra(ast_ind,1:4);

c_tet_2 = (1/4)*(nodes(tet_ast_2(:,1),:) + nodes(tet_ast_2(:,2),:) + nodes(tet_ast_2(:,3),:) + nodes(tet_ast_2(:,4),:));

ind_m = [ 2 4 3 ;
          1 3 4 ;
          1 4 2 ;
          1 2 3 ];

for i = 1 : 3

if i == 1
subplot(1,3,1); view([-1 0 0]);
I_cut = find(c_tet_2(:,1)>clipping_plane_x);
elseif i == 2
subplot(1,3,2);  view([0 -1 0]);
I_cut = find(c_tet_2(:,2)>clipping_plane_y);
elseif i == 3
subplot(1,3,3); view([0 0 -1]);
I_cut = find(c_tet_2(:,3)>clipping_plane_z);
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
p_vec_plot = x(interp_vec(ast_ind)); %p_vec(ast_ind);

I_aux = find(p_vec_plot<0);
p_vec_plot(I_aux) = -p_vec_plot(I_aux);

p_vec_plot = p_vec_plot/max(abs(p_vec_plot(:)));
p_vec_plot = max(db(p_vec_plot),-thresh_val)+thresh_val;

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
material([0.6 0.05 0]);
axis equal;
axis tight;

c_length = 2048; alpha = 0.9; 
c_map = [[linspace(1,alpha,c_length) linspace(alpha^2,0,c_length).^(1/2)]' [linspace(0,alpha^2,c_length).^(1/2) linspace(alpha^2,0,c_length).^(1/2)]' [linspace(0,alpha^2,c_length).^(1/2) linspace(alpha,1,c_length)]'];
c_map = c_map(end-c_length:end,:);
colormap(c_map);
set(gca,'clim',[0 thresh_val])

h_c_bar = colorbar('horizontal','location','southoutside');
h_c_bar.Limits = [0 thresh_val];

set(1,'Position',[113 513 1173 392]);

end
 
%print(fig,'asteroid_inversion', '-dpng')
