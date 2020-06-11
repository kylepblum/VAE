W = csvread('../../Result/weights_mexican_som.csv');
test = csvread('../../Dataset/test_sub.csv');

r = test*W;
[~,PD] = max(r);

[PDdiff, fit_result] = get_PDdiff(PD);

h1 = figure;
axes1 = axes;
hold(axes1,'on');
set(h1,'Position',[10 10 610 278])
x = [10:10:180];
barp = PDdiff; 
bar1 = bar(x,barp','EdgeColor','none');
ylim([0,0.3]);
set(bar1(2),...
    'FaceColor',[0.929411764705882 0.694117647058824 0.125490196078431]);
set(bar1(3),...
    'FaceColor',[0.501960784313725 0.501960784313725 0.501960784313725]);

ft = fittype('a*exp(-b*x)+c');
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.StartPoint = [0.55870305634287 0.808037493359497 0.70576432051369];
y = barp(1,:);
[f,gof] = fit(x',y','exp1');
plot([0:180],f([0:180]),'k','LineWidth',1.5);hold on;
% plot(x, 0.1468*exp(-0.01146*x),'k--');hold on;
% plot(x, 0.2419*exp(-0.0225*x),'k--');hold on;

box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',14,'XTick',...
    x,'XTickLabel',...
    {'10','20','30','40','50','60','70','80','90','100','110','120','130','140','150','160','170','180'},...
    'XTickLabelRotation',45);

PDcar = subangle2carangle(PD)/180*3.1415626;
bins = 36;

figure;
h1 = polarhistogram(PDcar,bins,'LineWidth',2,...
    'Normalization','probability','EdgeColor','k','FaceAlpha',0.0);
h1.DisplayStyle = 'stairs';
hold on;

h3 = polarhistogram(PDcar,bins,...
    'FaceAlpha',0.2,'EdgeColor','None',...
    'Normalization','probability','FaceColor','k');hold on;

