%Copyright © 2021- Sampsa Pursiainen & GPU-ToRRe-3D Development Team
%See: https://github.com/sampsapursiainen/GPU-Torre-3D


db_vec = [-25:5:0];
%angle_val = 90;
%plot_type = 2;

if plot_type == 1;

f_num = 1;
if angle_val == 90
data_vec_1 = monostatic.angle_90.ROE_SURF;
data_vec_2 = bistatic.angle_90.ROE_SURF;
y_lim = [30 55];
elseif angle_val == 30 
data_vec_1 = monostatic.angle_30.ROE_SURF;
data_vec_2 = bistatic.angle_30.ROE_SURF;
y_lim = [40 57.5];
elseif angle_val == 10
data_vec_1 = monostatic.angle_10.ROE_SURF;
data_vec_2 = bistatic.angle_10.ROE_SURF;
y_lim = [40 65];
end

plot_boxplot(f_num,db_vec,y_lim,data_vec_1,data_vec_2);

f_num = 2;
if angle_val == 90
data_vec_1 = monostatic.angle_90.ROE_DEEP;
data_vec_2 = bistatic.angle_90.ROE_DEEP;
y_lim = [5 50];
elseif angle_val == 30 
data_vec_1 = monostatic.angle_30.ROE_DEEP;
data_vec_2 = bistatic.angle_30.ROE_DEEP;
y_lim = [5 70];
elseif angle_val == 10 
data_vec_1 = monostatic.angle_10.ROE_DEEP;
data_vec_2 = bistatic.angle_10.ROE_DEEP;
y_lim = [10 80];
end
plot_boxplot(f_num,db_vec,y_lim,data_vec_1,data_vec_2);

f_num = 3;
if angle_val == 90
data_vec_1 = monostatic.angle_90.ROE_TOT;
data_vec_2 = bistatic.angle_90.ROE_TOT;
y_lim = [30 50];
elseif angle_val == 30 
data_vec_1 = monostatic.angle_30.ROE_TOT;
data_vec_2 = bistatic.angle_30.ROE_TOT;
y_lim = [35 60];
elseif angle_val == 10 
data_vec_1 = monostatic.angle_10.ROE_TOT;
data_vec_2 = bistatic.angle_10.ROE_TOT;
y_lim = [40 60];
end

plot_boxplot(f_num,db_vec,y_lim,data_vec_1,data_vec_2);


elseif plot_type == 2


f_num = 1;
if angle_val == 90
data_vec_1 = monostatic.angle_90.RVE_SURF;
data_vec_2 = bistatic.angle_90.RVE_SURF;
y_lim = [0 35];
elseif angle_val == 30 
data_vec_1 = monostatic.angle_30.RVE_SURF;
data_vec_2 = bistatic.angle_30.RVE_SURF;
y_lim = [15 90];
elseif angle_val == 10
data_vec_1 = monostatic.angle_10.RVE_SURF;
data_vec_2 = bistatic.angle_10.RVE_SURF;
y_lim = [20 120];
end

plot_boxplot(f_num,db_vec,y_lim,data_vec_1,data_vec_2);

f_num = 2;
if angle_val == 90
data_vec_1 = monostatic.angle_90.RVE_DEEP;
data_vec_2 = bistatic.angle_90.RVE_DEEP;
y_lim = [30 75];
elseif angle_val == 30 
data_vec_1 = monostatic.angle_30.RVE_DEEP;
data_vec_2 = bistatic.angle_30.RVE_DEEP;
y_lim = [30 110];
elseif angle_val == 10 
data_vec_1 = monostatic.angle_10.RVE_DEEP;
data_vec_2 = bistatic.angle_10.RVE_DEEP;
y_lim = [25 120];
end
plot_boxplot(f_num,db_vec,y_lim,data_vec_1,data_vec_2);

f_num = 3;
if angle_val == 90
data_vec_1 = monostatic.angle_90.RVE_TOT;
data_vec_2 = bistatic.angle_90.RVE_TOT;
y_lim = [0 70];
elseif angle_val == 30 
data_vec_1 = monostatic.angle_30.RVE_TOT;
data_vec_2 = bistatic.angle_30.RVE_TOT;
y_lim = [0 150];
elseif angle_val == 10 
data_vec_1 = monostatic.angle_10.RVE_TOT;
data_vec_2 = bistatic.angle_10.RVE_TOT;
y_lim = [0 150];
end
plot_boxplot(f_num,db_vec,y_lim,data_vec_1,data_vec_2);


end
