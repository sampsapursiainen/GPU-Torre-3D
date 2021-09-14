parameters;

N=50000; m=5;
alpha= [60 0 0 30 0 ];
beta= [0 60 0 30 55 ];
gamma= [0 0 60 0 30];

ellipsoid = [2 1 1; 2 1 1; 1 1 1; 2 1 1; 2 1 1];
translation_vec = [1 0 1; 0 1 1; 1 0 0; 0 0 1; 0 1 0];
point_cloud=[];
p_vec=[];
colo = {'r','g','b','c','m'};
point_cloud_mass_vec = 0.2E-22*[1 2 3 4 5]; 
point_cloud_size_vec = 1.8E-10*[1 1 1 1 1];
point_cloud_spatial_scale = [5E-9];

figure(1);
clf;
hold on;

for i=1:m

P=randn(3,N);
r_x= [1       0             0 ;
0 cosd(alpha(i)) -sind(alpha(i)) ;
0 sind(alpha(i)) cosd(alpha(i)) ];

r_y= [ cosd(beta(i)) 0 -sind(beta(i));
        0            1    0;
    sind(beta(i)) 0 cosd(beta(i))];


r_z= [ cosd(gamma(i)) -sind(gamma(i)) 0;
    sind(gamma(i)) cosd(gamma(i))    0;
    0            0                   1];

R= r_x*r_y*r_z;
P = point_cloud_spatial_scale*(R*diag(ellipsoid(i,:))*R'*P+repmat(translation_vec(i,:)',1,size(P,2)));
point_cloud = [point_cloud ; point_cloud_mass_vec(i)*ones(size(P,2),1) point_cloud_size_vec(i)*ones(size(P,2),1) P' i*ones(size(P,2),1)];

scatter3(P(1,:),P(2,:),P(3,:),colo{i})

end

pbaspect([1 1 1]);
rotate3d;

save([torre_dir '/model_data/' point_cloud_file_name],'point_cloud','-ascii');