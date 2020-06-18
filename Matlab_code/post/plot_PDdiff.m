close all
load ../../Result/PDResult_new.mat
load ../../Result/EXPResult.mat

% sigma = {'1_4','1_6','1_8','2'};
h1 = figure;
axes1 = axes;
hold(axes1,'on');
set(h1,'Position',[10 10 610 278])
x = [10:10:180];
barp = PDdiff; %Result(2,9).PDdiff;
bar1 = bar(x,barp','EdgeColor','none');
ylim([0,0.2]);
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
plot(x,f(x),'k','LineWidth',1.5);hold on;
% plot(x, 0.1468*exp(-0.01146*x),'k--');hold on;
% plot(x, 0.2419*exp(-0.0225*x),'k--');hold on;

box(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontSize',14,'XTick',...
    x,'XTickLabel',...
    {'10','20','30','40','50','60','70','80','90','100','110','120','130','140','150','160','170','180'},...
    'XTickLabelRotation',45);