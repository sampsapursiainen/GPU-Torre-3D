%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D
 
%This script creates a finite element mesh given the volumetric data.
%********************************************************************
%Set parameters
%********************************************************************
parameters;

%********************************************************************
%Script starts here. 
%********************************************************************

load_volumetric_data;

command = [gmsh_full_file_name ' ' gmsh_geo_file_name ' -3 -format mesh -o ' gmsh_msh_file_name];
[status,cmdout] = system(command)

msh_file_lines = readlines(gmsh_msh_file_name);

nodes_start = 0;
nodes_end = 0;
elements_start = 0;
elements_end = 0;

for i = 1 : length(msh_file_lines)
    
   if isequal(strtrim(msh_file_lines{i}), 'Vertices')
       nodes_start = i + 2; 
   end
    if isequal(strtrim(msh_file_lines{i}), 'Tetrahedra')
       nodes_end = i - 1; 
       elements_start = i + 2;
    end
    if isequal(strtrim(msh_file_lines{i}), 'End')
       elements_end = i - 1; 
   end
end

nodes = zeros(nodes_end - nodes_start + 1,4);
tetrahedra = zeros(elements_end - elements_start + 1,5);

 for i = nodes_start : nodes_end
     nodes(i-nodes_start+1,:) = str2num(strtrim(msh_file_lines{i}));
 end
 
  for i = elements_start : elements_end
     tetrahedra(i-elements_start+1,:) = str2num(strtrim(msh_file_lines{i}));
  end
  
  for i = 1 : n_mesh_generation_refinement
    [nodes,tetrahedra] = refine_mesh(nodes(:,1:3),tetrahedra);
 end
 
  unique_domain_number = sort(unique(tetrahedra(:,5)));
  domain_number_aux = zeros(max(unique_domain_number));
  domain_number_aux(unique_domain_number) = [1 2 3]; 
  tetrahedra(:,5) = domain_number_aux(tetrahedra(:,5));
  nodes = nodes(:,1:3);
  asteroid_domain_number = 1;
  asteroid_I = find(tetrahedra(:,5) == asteroid_domain_number);
  asteroid_c_nodes = 0.25*(nodes(tetrahedra(asteroid_I,1),1:3)+nodes(tetrahedra(asteroid_I,2),1:3)+nodes(tetrahedra(asteroid_I,3),1:3)+nodes(tetrahedra(asteroid_I,4),1:3));
  asteroid_c_nodes_ind = zeros(size(asteroid_c_nodes));
  
lattice_size_vec = [lattice_size_x lattice_size_y lattice_size_z];   
lattice_min_vec = [min(x_lattice(:)) min(y_lattice(:)) min(z_lattice(:))];
for i = 1 : 3
asteroid_c_nodes_ind(:,i) = max(1,min(lattice_resolution, round((asteroid_c_nodes(:,i) - lattice_min_vec(i))/lattice_size_vec(i))+1));
end
 
asteroid_c_nodes_ind = asteroid_c_nodes_ind(:,2)  + lattice_resolution*(asteroid_c_nodes_ind(:,1)-1) + lattice_resolution^2*(asteroid_c_nodes_ind(:,3)-1);

real_relative_permittivity = ones(size(tetrahedra,1),1);
imaginary_relative_permittivity = ones(size(tetrahedra,1),1);

if system_setting_index == 1
real_relative_permittivity(asteroid_I) = real_relative_permittivity_bg;
imaginary_relative_permittivity(asteroid_I) = imaginary_relative_permittivity_bg;
else
real_relative_permittivity(asteroid_I) = real(relative_permittivity_lattice(asteroid_c_nodes_ind));
imaginary_relative_permittivity(asteroid_I) = imag(relative_permittivity_lattice(asteroid_c_nodes_ind));
end

save([torre_dir '/system_data/tetrahedra_' int2str(system_setting_index) '.dat'], 'tetrahedra','-ascii');
 save([torre_dir '/system_data/nodes_' int2str(system_setting_index) '.dat'], 'nodes','-ascii');
 save([torre_dir '/system_data/real_relative_permittivity_' int2str(system_setting_index) '.dat'], 'real_relative_permittivity','-ascii'); 
 save([torre_dir '/system_data/imaginary_relative_permittivity_' int2str(system_setting_index) '.dat'], 'imaginary_relative_permittivity','-ascii'); 
 
 
 asteroid_c_nodes = 0.25*(nodes(tetrahedra(:,1),1:3)+nodes(tetrahedra(:,2),1:3)+nodes(tetrahedra(:,3),1:3)+nodes(tetrahedra(:,4),1:3));
 
 figure(4); clf;
 view_mat = [1 0 0; 0 1 0; 0 1e-15 1];
 title_cell = {'Full domain, x-view','Full domain, y-view','Full domain, z-view'};
 for i = 1 : 3
 I = find(asteroid_c_nodes(:,i)<0);
 [FB, FB_ind] = free_boundary(tetrahedra(I,1:4));
 subplot(1,3,i);
 trisurf(FB,nodes(:,1),nodes(:,2),nodes(:,3),tetrahedra(I(FB_ind),5));
 view(view_mat(i,:))
 axis tight
 axis equal
 title(title_cell{i})
 colormap('lines')
 shading flat
 end
 
 figure(5); clf;
 view_mat = [1 0 0; 0 1 0; 0 1e-15 1];
 title_cell = {'Real relative permittivity, x-view','Real relative permittivity, y-view','Real relative permittivity, z-view'};
 for i = 1 : 3
 I = find(asteroid_c_nodes(asteroid_I,i)<0);
 [FB, FB_ind] = free_boundary(tetrahedra(asteroid_I(I),1:4));
 subplot(1,3,i);
 trisurf(FB,nodes(:,1),nodes(:,2),nodes(:,3),real_relative_permittivity(asteroid_I(I(FB_ind))));
 view(view_mat(i,:))
 axis tight
 axis equal
 title(title_cell{i})
 colormap('turbo')
 %set(gca,'visible','off')
 colorbar horiz
 shading flat
 end
 
 figure(6); clf;
 view_mat = [1 0 0; 0 1 0; 0 1e-15 1];
 title_cell = {'Imaginary relative permittivity, x-view','Imaginary relative permittivity, y-view','Imaginary relative permittivity, z-view'};
 for i = 1 : 3
 I = find(asteroid_c_nodes(asteroid_I,i)<0);
 [FB, FB_ind] = free_boundary(tetrahedra(asteroid_I(I),1:4));
 subplot(1,3,i);
 trisurf(FB,nodes(:,1),nodes(:,2),nodes(:,3),imaginary_relative_permittivity(asteroid_I(I(FB_ind))));
 view(view_mat(i,:))
 axis tight
 axis equal
 title(title_cell{i})
 colormap('turbo')
 %set(gca,'visible','off')
 colorbar horiz
 shading flat
 end
   
 [smrt_0, tst_0, smrt_5, tst_5] = evaluate_courant_condition(nodes,tetrahedra,real_relative_permittivity,signal_center_frequency+signal_bandwidth,courant_number)
   
 disp('**************************************************************************') 
 disp([ 'FEM mesh for system ' int2str(system_setting_index) '.'])
 disp('**************************************************************************') 
 disp(' ')
 disp([ 'Number of nodes: ' int2str(length(nodes)) ])
 disp(['Number of tetrahedra: ' int2str(length(tetrahedra))])
 disp(' ')
 disp('To satisfy the Nyquist and Courant condition with the current center')
 disp(['frequency ' sprintf('%0.3g',signal_center_frequency) ' and bandwidth ' sprintf('%0.3g',signal_bandwidth) ' the suggested number of uniform spatial'])
 disp('mesh refinements n_refinement (Nyquist) and the corresponding time step')
 disp(['d_t (Courant) are'])
 disp(' ')
 disp(['n_refinement = ' int2str(smrt_0)])
 disp(['d_t = ' sprintf('%0.5g',tst_0)])
 disp(' ')
 disp(['with zero tolerance for edges larger than the half of the shortest'])
 disp(['wavelength, and'])
 disp(' ')
 disp(['n_refinement = ' int2str(smrt_5)])
 disp(['d_t = ' sprintf('%0.5g',tst_5) ','])
 disp(' ')
 disp(['when the 5 % of the edges are allowed to exceed that limit.'])
 disp(' ')
 disp('**************************************************************************') 
   
     
   