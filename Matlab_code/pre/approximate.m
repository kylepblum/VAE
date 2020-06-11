load('../../Dataset/planar_data.mat');
idx = [7001:9000];
joint_vel = data.jointvelocity(idx,:);
joint_angle = data.jointangle(idx,:);
end_vel = data.endvelocity(idx,:);
end_pos = data.endposition(idx,:);

[a,b,variance] = pca(joint_vel);

load('idxes.mat');

idx = set_out;
[theta, rho] = cart2pol(end_pos(idx,1)-mean(end_pos(idx,1)),end_pos(idx,2)-mean(end_pos(idx,2)));
idx = idx(find(rho<3));

[theta_sub, rho_sub] = cart2pol( b(idx,1),b(idx,2));
[theta_car, rho_car] = cart2pol(end_vel(idx,1),end_vel(idx,2));

theta_sub = theta_sub/3.1415926*180;
theta_car = theta_car/3.1415926*180;

predict1 = [theta_sub, rho_sub, theta_car];
predict2 = [theta_sub, rho_sub, rho_car];