%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


load([torre_dir '/system_data/mesh_3D_1.mat'])

load([torre_dir '/system_data/nodes_1.dat'])
load([torre_dir '/system_data/tetrahedra_1.dat'])

ast_ind_coarse = unique(interp_vec(ast_ind));
tet_ast = tetrahedra_1(ast_ind_coarse,6:9);
c_tet = (nodes_1(tet_ast(:,1),2:4) + nodes_1(tet_ast(:,2),2:4) + nodes_1(tet_ast(:,3),2:4)+ nodes_1(tet_ast(:,4),2:4))/4;                                           

Aux_mat = [nodes_1(tet_ast(:,1),2:4)'; nodes_1(tet_ast(:,2),2:4)'; nodes_1(tet_ast(:,3),2:4)'] - repmat(nodes_1(tet_ast(:,4),2:4)',3,1);
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
tilavuus_1 = abs(Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
                - Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
                + Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;

load([torre_dir '/system_data/mesh_3D_2.mat'])
load([torre_dir '/system_data/system_data_3D_2.mat'])

load([torre_dir '/system_data/nodes_2.dat'])
load([torre_dir '/system_data/tetrahedra_2.dat'])

ast_ind_coarse_2 = unique(interp_vec(ast_ind));
tet_ast_2 = tetrahedra_2(ast_ind_coarse_2,6:9);
x_exact = p_vec(ast_ind_coarse_2);
c_tet_2 = (nodes_2(tet_ast_2(:,1),2:4) + nodes_2(tet_ast_2(:,2),2:4) + nodes_2(tet_ast_2(:,3),2:4)+ nodes_2(tet_ast_2(:,4),2:4))/4;       

Aux_mat = [nodes_2(tet_ast_2(:,1),2:4)'; nodes_2(tet_ast_2(:,2),2:4)'; nodes_2(tet_ast_2(:,3),2:4)'] - repmat(nodes_2(tet_ast_2(:,4),2:4)',3,1);
ind_m = [1 4 7; 2 5 8 ; 3 6 9];
tilavuus_2 = abs(Aux_mat(ind_m(1,1),:).*(Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,2),:)) ...
                - Aux_mat(ind_m(1,2),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,3),:)-Aux_mat(ind_m(2,3),:).*Aux_mat(ind_m(3,1),:)) ...
                + Aux_mat(ind_m(1,3),:).*(Aux_mat(ind_m(2,1),:).*Aux_mat(ind_m(3,2),:)-Aux_mat(ind_m(2,2),:).*Aux_mat(ind_m(3,1),:)))/6;

roi_interp_vec = zeros(size(c_tet_2,1),1);
for i = 1 : size(c_tet_2,1)

[m_v, m_i] = min(sum((c_tet - c_tet_2(i*ones(size(c_tet,1),1),:)).^2,2));
roi_interp_vec(i) = m_i;

end

roi_ind = find(ismember(tetrahedra_2(ast_ind_coarse_2,4),[1 5 6 7]));
deep_ind = find(ismember(tetrahedra_2(ast_ind_coarse_2,4),[5 6 7]));
surf_ind= find(ismember(tetrahedra_2(ast_ind_coarse_2,4),[1]));
tilavuus_roi = sum(tilavuus_2(roi_ind));
tilavuus_deep = sum(tilavuus_2(deep_ind));
tilavuus_surf = sum(tilavuus_2(surf_ind));

%save ./system_data/roi_data.mat c_tet c_tet_2 tet_ast tet_ast_2 nodes_1 nodes_2 tilavuus_1 tilavuus_2 x_exact roi_ind roi_interp_vec tilavuus_roi
