% load('../../Dataset/planar_data.mat');
% idx = [7001:9000];
% joint_vel = data.jointvelocity(idx,:);
% joint_angle = data.jointangle(idx,:);
% end_vel = data.endvelocity(idx,:);
% end_pos = data.endposition(idx,:);
% 
% [a,b,variance] = pca(joint_vel);
% joint_vel_2D = b(:,1:2);
% trans = a(:,1:2);
% save('pca_planar.mat','trans','variance');

v = sqrt(sum(end_vel'.^2));

mask1 = v(1:end-2)>v(2:end-1);
mask2 = v(3:end)>v(2:end-1);
mask3 = v(2:end-1)<10;
mask = mask1 & mask2 & mask3;
mask(45) = 0;

delimeter = find(mask==1)+1;

% plot(v); hold on; plot(delimeter, v(delimeter),'*');
delimeter = [1,delimeter,length(v)+1];
set_out = [];
set_back = [];
for i = 1:length(delimeter)-1
    if mod(i,2) == 1
        set_out = [set_out,delimeter(i):delimeter(i+1)-1];
    else
        set_back = [set_back,delimeter(i):delimeter(i+1)-1];
    end
end

% bar(set_out, 2*ones(1,length(set_out)));hold on;
% bar(idx, ones(1,length(idx)));

save('idxes.mat','set_out','set_back');
    