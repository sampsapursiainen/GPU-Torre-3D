%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


function [source_angle, path_data, f_rec_data] = if2gputorre3d(dstruc, difcal, receiver_angle_difference)

dstruc.phis = repmat(dstruc.phis,1,size(dstruc.phio,2));
dstruc.phio = dstruc.phio;

I = find(not(isnan(dstruc.phio(:))));
I = I(:);
[J K] = ind2sub(size(dstruc.phio),I);

source_angle_t = [dstruc.phis(I) dstruc.phio(I)];

f_rec_data = cell(0);

path_data = [1:length(I)]'; 

source_angle = source_angle_t;

for i = 1 : size(receiver_angle_difference,1)

   path_data = [path_data i*length(I)+path_data(:,1)];
   source_angle = [source_angle ; source_angle_t + receiver_angle_difference(i,:)];
  
   if not(isempty(difcal))
     for j = 1 : length(I)
     f_rec_data{j,i+1} = difcal(J(j),i,K(j),:);
     end
   end
   
end

end