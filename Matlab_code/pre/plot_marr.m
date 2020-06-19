
sigma = 2;

d = [0:0.01:10];

tmp = 0.5*d.^2/sigma^2;
idx = 282;
y = 1/(3.14159*sigma^2).*(1-tmp).*exp(-tmp);
c1 = [204,253,196]/255;
c2 = [245,194,193]/255;

h1 = figure;
plot_shaded(d(1:idx)',y(1:idx)','Color',c1);hold on
plot_shaded(d(idx:end)',y(idx:end)','Color',c2);hold on
plot(d,y,'k','LineWidth',2);
set(h1,'position',[0,0,300,300]);