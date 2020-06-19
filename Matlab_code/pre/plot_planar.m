load('../../Dataset/planar_data.mat');
idx = [7001:9000];
joint_vel = data.jointvelocity(idx,:);
joint_angle = data.jointangle(idx,:);
end_vel = data.endvelocity(idx,:);
end_pos = data.endposition(idx,:);

[a,b,variance] = pca(joint_vel);
joint_vel_2D = b(:,1:2);
trans = a(:,1:2);
save('pca_planar.mat','trans','variance');

load('idxes.mat');

%% figure : general plot of velocity/angular velocity
figure;
idx = set_out;


[theta, rho] = cart2pol(end_pos(idx,1)-mean(end_pos(idx,1)),end_pos(idx,2)-mean(end_pos(idx,2)));
idx = idx(find(rho<3));


for i = 1:length(idx)
    id = idx(i);
    c = [theta2(id)/3.1415927/2,1,1];
    sub2 = subplot(1,2,2); xlim([-90,90]); ylim([-90,90]);
    plot(end_vel(id,1),end_vel(id,2),'.','Color', hsv2rgb(c)); hold on
    sub1 = subplot(1,2,1); xlim([-220,220]); ylim([-220,220]);
    plot(b(id,1),b(id,2),'.','Color', hsv2rgb(c)); hold on
end
set(gcf,'position',[0,0,750,300]);
set(sub1,'FontSize',14,'XTick',[-200:100:200], 'YTick',[-200:100:200]);
set(sub2,'FontSize',14,'XTick',[-80:40:80], 'YTick',[-80:40:80]);
% 
% for speed = 5:5:20
%     subplot(1,3,1);
%     x = squeeze(test_vec_cart(:,speed,:));
%     x(end+1,:) = x(1,:);
%     plot(x(:,1),x(:,2),'k');hold on;
%     subplot(1,3,2);
%     x = squeeze(test_vec_joint(:,speed,:));
%     x(end+1,:) = x(1,:);
%     plot(x(:,1),x(:,2),'k');hold on;
% end
% 
% ylim([-200,100]);
% close all

