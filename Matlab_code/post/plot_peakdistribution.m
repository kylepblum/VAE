load Sample.mat
distribution = 'Gamma';
peakrate = Sample.PR;

c1 = [79,133,193]/255;
c2 = [203,102,59]/255;

p1 = peakrate(2,:)-9;
p2 = peakrate(5,:)-9;

h1 = figure;
sub1 = subplot(1,1,1);
[y,bin_edges1] = histcounts(p1,[0:1:40],'Normalization','probability');
dx = (bin_edges1(2)-bin_edges1(1));
x = bin_edges1(1:end-1)+0.5*dx;

bar(x,y,'FaceColor',c1,'EdgeColor','none','FaceAlpha',0.4);hold on;
pd1 = fitdist(p1',distribution);
xx = [0:0.2:40];
y_dis = pdf(pd1,xx)*dx;
plot(xx,y_dis,'LineWidth',2);xlim([0,30]);ylim([0,0.25]);
% set(sub1,'FontSize',14);

res = sum((pdf(pd1,x)*dx - y).^2);
var = sum(y.^2);
r2 = 1-res/var;
r2

% sub2 = subplot(1,2,2);
[y,bin_edges2] = histcounts(p2,[0:1:40],'Normalization','probability');
dx = (bin_edges2(2)-bin_edges2(1));
x = bin_edges2(1:end-1)+0.5*dx;
bar(x,y,'FaceColor',c2,'EdgeColor','none','FaceAlpha',0.4);hold on;
pd2 = fitdist(p2',distribution);
y_dis = pdf(pd2,xx)*dx;
plot(xx,y_dis,'LineWidth',2);xlim([0,30]);ylim([0,0.25]);
% set(sub2,'FontSize',14);
set(h1,'Position',[10 10 510 310]);
set(sub1,'FontSize',14);

res = sum((pdf(pd2,x)*dx - y).^2);
var = sum(y.^2);
r2 = 1-res/var;
r2