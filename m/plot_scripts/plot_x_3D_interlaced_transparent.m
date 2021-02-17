%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


load([torre_dir '/system_data/mesh_1.mat']);
load([torre_dir '/system_data/system_data_1.mat'],'p_vec');
p_vec_1 = p_vec;

center_points_1 = (1/4)*(nodes_ast(tetra_ast(:,1),:) + nodes_ast(tetra_ast(:,2),:) + nodes_ast(tetra_ast(:,3),:) + nodes_ast(tetra_ast(:,4),:))';

load([torre_dir '/system_data/mesh_2.mat']);
load([torre_dir '/system_data/system_data_2.mat'],'p_vec');
p_vec_2 = p_vec;

center_points_2 = (1/4)*(nodes_ast(tetra_ast(:,1),:) + nodes_ast(tetra_ast(:,2),:) + nodes_ast(tetra_ast(:,3),:) + nodes_ast(tetra_ast(:,4),:))';

size_center_points_2 = size(center_points_2,2);
center_points_1 = gpuArray(center_points_1);
center_points_2 = gpuArray(center_points_2);
scalar_field_interpolation_vec = zeros(length(center_points_2),1);
scalar_field_interpolation_vec = gpuArray(scalar_field_interpolation_vec);
ones_vec = ones(size(center_points_1,2),1);

par_num = 50;
bar_ind = ceil(size_center_points_2/(50*par_num));
loop_index_aux = 0;

tic;

h = waitbar(1,['Interpolation ready: ' datestr(datevec(now+(size_center_points_2/i - 1)*time_val/86400)) '.']);

for i = 1 : par_num : size_center_points_2

loop_index_aux = loop_index_aux + 1;
block_ind = [i: min(i+par_num-1,size_center_points_2)];
aux_vec = center_points_2(:,block_ind);
aux_vec = reshape(aux_vec,3,1,length(block_ind));
norm_vec = sum((center_points_1(:,:,ones(1,length(block_ind))) - aux_vec(:,ones_vec,:)).^2);
[min_val min_ind] = min(norm_vec,[],2);
scalar_field_interpolation_vec(block_ind) = min_ind(:);

time_val = toc;
if mod(loop_index_aux,bar_ind)==0 || i == size_center_points_2
waitbar(i/size_center_points_2,h,['Interpolation ready: ' datestr(datevec(now+(size_center_points_2/i - 1)*time_val/86400)) '.']);
end

end

close(h);

figure(1); clf;

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

x_aux = x(scalar_field_interpolation_vec);
p_vec_plot_1 = x_aux(interp_vec(ast_ind)); %p_vec(ast_ind);

I_aux = find(p_vec_plot_1<0);
p_vec_plot_1(I_aux) = -p_vec_plot_1(I_aux);

p_vec_plot_1 = p_vec_plot_1/max(abs(p_vec_plot_1(:)));
p_vec_plot_1 = max(db(p_vec_plot_1),-thresh_val)+thresh_val;

p_vec_plot_2 = p_vec_2(ast_ind)-max(p_vec_1); %x(interp_vec(ast_ind)); %p_vec(ast_ind);

I_aux = find(p_vec_plot_2<0);
p_vec_plot_2(I_aux) = -p_vec_plot_2(I_aux);

p_vec_plot_2 = p_vec_plot_2/max(abs(p_vec_plot_2(:)));
p_vec_plot_2 = max(db(p_vec_plot_2),-thresh_val)+thresh_val;


c_length = 2048;
p_vec_plot_2 = p_vec_plot_2 + thresh_val + thresh_val/c_length;



I = I_cut(I);
X_data = nodes(:,1);
Y_data = nodes(:,2);
Z_data = nodes(:,3);
hold on;

h_ast_1 = patch(X_data(I2), Y_data(I2), Z_data(I2),p_vec_plot_2(I));
set(h_ast_1,'edgecolor','none','facealpha',1);
set(gca,'visible','off');
shading flat;
material([0.6 0.05 0]);
axis equal;
axis tight;

hold on

h_ast_2 = patch(X_data(I2), Y_data(I2), Z_data(I2),p_vec_plot_1(I));
set(h_ast_2,'edgecolor','none','facealpha',0.7);
hold off;

alpha = 0.9; 
c_map = [[linspace(1,alpha,c_length) linspace(alpha^2,0,c_length).^(1/2)]' [linspace(0,alpha^2,c_length).^(1/2) linspace(alpha^2,0,c_length).^(1/2)]' [linspace(0,alpha^2,c_length).^(1/2) linspace(alpha,1,c_length)]'];
c_map = c_map(end-c_length:end,:);
c_map = [c_map ; flipud(gray(c_length))];
colormap(c_map);
set(gca,'clim',[0 2*thresh_val])

h_c_bar_1 = colorbar('horizontal','location','southoutside');
h_c_bar_1.Limits = [0 thresh_val];

h_c_bar_2 = colorbar('horizontal','location','northoutside');
h_c_bar_2.Limits = [thresh_val+thresh_val/c_length 2*thresh_val];
h_c_bar_2.Ticks = h_c_bar_1.Ticks + thresh_val;
h_c_bar_2.TickLabels = h_c_bar_1.TickLabels;


set(1,'Position',[113 513 1173 392]);


end
 
%print(fig,'asteroid_inversion', '-dpng')
