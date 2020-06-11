axes = subplot(1,1,1);
load('pca_planar.mat');
X = csvread('../../Dataset/train.csv');
[a,b,v_natural] = pca(X);

save('pca_natural.mat','v_natural','a');

variance_recovered_planar = cumsum(variance)/sum(variance);
variance_recovered_natural = cumsum(v_natural)/sum(v_natural);

variance_recovered_planar = [0;variance_recovered_planar];
variance_recovered_natural = [0;variance_recovered_natural];

tmp = [variance_recovered_planar, variance_recovered_natural];
bar([0:9], tmp,...
    'EdgeColor','none',...
    'BarWidth',0.7);
xlim([0,10]);ylim([0,1.1]);
set(axes,'FontSize',14,'XTick',[0 1 2 3 4 5 6 7 8 9]);
set(gcf,'position',[0,0,400,300]);

% complexity

