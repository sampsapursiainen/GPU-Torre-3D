%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


tic
system_setting_index = 1;
parameters;

n_iter = 3;
pcg_iter = 1000;
pcg_tol = 1E-6;
eps_val = 1e-2;
alpha = 1e-9;
beta = alpha*0.1;

x_cell = cell(0);
W_mat = (alpha*TV_D + beta*speye(size(L{1},2),size(L{1},2)));

for k = 1 : length(L)

k

x_cell{k} = zeros(size(L{k},2),1);
theta = ones(size(x_cell{k}));

for i = 1 : n_iter   
    
D = spdiags(1./theta, 0, length(x_cell{k}), length(x_cell{k}));
[x_cell{k}, conv_val, n_it] = pcg_solve(L{k}, W_mat, D, L{k}'*y{k}, pcg_tol, pcg_iter);

theta = sqrt((W_mat*x_cell{k}).^2);
theta = theta + eps_val*max(abs(theta));
%gamma = sqrt(norm(theta));

end

end

x = zeros(size(x_cell{1}));
for k = 1 : length(x_cell)
x = x + x_cell{k};
end
x = x/length(x_cell);





