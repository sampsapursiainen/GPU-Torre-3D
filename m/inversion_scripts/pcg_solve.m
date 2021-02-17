%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D



function [x,conv_val,n_iter] = pcg_solve(R, W_mat, D_mat, b, tol_val, max_it)

x = zeros(size(R,2),1);
r = b;
p = r;
j = 1;

conv_val_aux = sqrt(sum(b.^2));
conv_val = sqrt((sum(r.^2))); 

while (conv_val/conv_val_aux > tol_val) & (j < max_it)
    aux_vec_1 = R*p;
    aux_vec_2 = D_mat*(W_mat*p);
    aux_vec = R'*aux_vec_1 + W_mat'*aux_vec_2;
    alpha = sum(r.*r)./sum(p.*aux_vec);
    x = x + alpha(ones(size(p,1),1),:).*p;
    rnew = r - alpha(ones(size(p,1),1),:).*aux_vec;
    beta = sum(rnew.*rnew)./sum(r.*r);
    p = rnew + beta(ones(size(p,1),1),:).*p;
    r = rnew;
    j = j + 1;
    conv_val = sqrt(sum(r.^2))/conv_val_aux;
end

n_iter = j;

return
