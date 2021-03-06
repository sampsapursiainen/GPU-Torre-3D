%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


figure(1);
clf;

I_cut = find(c_tet_2(:,3)>0); 
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
h_ast = patch(X_data(I2), Y_data(I2), Z_data(I2), p_vec_plot(I));
h_ast.EdgeColor = 'none';
h_ast.FaceAlpha = 'flat';
h_ast.FaceVertexAlphaData = 0.2;
view(-25,-20)
hold on;

%% Plot the isosurface
solmut = [tet_ast_2(:,1) p_vec_plot ; tet_ast_2(:,2) p_vec_plot; tet_ast_2(:,3) p_vec_plot; tet_ast_2(:,4) p_vec_plot];
s = unique(solmut,'rows');
x_s = nodes(s(:,1),1);
y_s = nodes(s(:,1),2);
z_s = nodes(s(:,1),3);
v_s = s(:,2);

dx = min(x_s):((max(x_s)-min(x_s))/100):max(x_s);
dy = min(y_s):((max(y_s)-min(y_s))/100):max(y_s);
dz = min(z_s):((max(z_s)-min(z_s))/100):max(z_s);
[xq,yq,zq] = meshgrid(dx,dy,dz);
vq = griddata(x_s,y_s,z_s,v_s,xq,yq,zq);
ota = find(vq < 1.1);
vq(ota) = 1;
p = patch(isosurface(xq,yq,zq,vq,1));
isonormals(xq,yq,zq,vq,p);
p.FaceColor = 'blue';
p.EdgeColor = 'none';
daspect([1 1 1])
%view(3);
axis tight
camlight 
lighting gouraud
xlabel('x')
ylabel('y')
zlabel('z')
hold off;
