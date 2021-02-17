%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D

%********************************************************************
%Set parameters
%********************************************************************
parameters;

%********************************************************************
%Script starts here. 
%********************************************************************
relative_permittivity_lattice = zeros(size(volumetric_density_lattice));
relative_permittivity_lattice_aux = cell(0);

if isequal(permittivity_mixture_model,'M-G')
 
for i = 1 : size(unique_color_vec,1)
relative_permittivity_lattice = max(relative_permittivity_lattice, (2.*filling_lattice{i}.*(relative_permittivity_vec(i)-1)+relative_permittivity_vec(i) + 2)./(2+relative_permittivity_vec(i)-filling_lattice{i}.*(relative_permittivity_vec(i)-1)));
end

else
    
for i = 1 : size(unique_color_vec,1)
     relative_permittivity_lattice_aux{i} = relative_permittivity_vec(i)*ones(size(relative_permittivity_lattice));
end


filling_lattice_aux_2 = filling_lattice;
   
 filling_lattice_aux_1 = zeros(size(filling_lattice{i}));
    for i = 1 : length(unique_color_vec)
       filling_lattice_aux_1 = filling_lattice_aux_1 + filling_lattice{i}; 
    end
    I = find(filling_lattice_aux_1(:)>1E-15/length(relative_permittivity_vec));
        for i = 1 : size(unique_color_vec,1)
       filling_lattice_aux_2{i}(I) = filling_lattice_aux_2{i}(I).^2./filling_lattice_aux_1(I); 
        end
        relative_permittivity_lattice = ones(size(filling_lattice{1}));
   for i = 1 : size(unique_color_vec,1)
   relative_permittivity_lattice = relative_permittivity_lattice - filling_lattice_aux_2{i} + filling_lattice_aux_2{i}.*relative_permittivity_lattice_aux{i}.^exponential_mixture_parameter;
   end
 relative_permittivity_lattice = relative_permittivity_lattice.^(1./exponential_mixture_parameter);    

end