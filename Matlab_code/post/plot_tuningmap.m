load ../../Result/rates_new.mat
x_sub = carangle2subangle([1:360]);
R_sample = X(:,:,1:100);
m1 = squeeze(R_sample(:,:,32));
m2 = squeeze(R_sample(:,:,45));

% h = figure;
% imagesc(m1(:,10:-1:1)'); colormap('jet');
% colorbar;

tuning_map(m2(x_sub,10:-1:1)'); 
xlim([1,360]);
ylim([0.5,10.5]);
% colormap('jet');
% colorbar; 
% caxis manual
% caxis([0 35]);
% h2CData = get(sub1,'CData');

%  subplot(1,2,2);
% sub2 =imagesc(m2(x_sub,10:-1:1)'); colormap('jet');
% colorbar; 
% set(sub3,'CData', h2CData );
set(gcf,'Position',[10 10 390 310]);
