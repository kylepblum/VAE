


load Sample.mat
f1 = figure;
axes1 = subplot(1,1,1);
set(axes1,'FontSize',14);
c1 = [79,133,193]/255;
c2 = [203,102,59]/255;
bins = 36;

PD1 = subangle2carangle(Sample.PD(2,:))/180*3.1415926;
h1 = polarhistogram(PD1,bins,'LineWidth',2,...
    'Normalization','probability','EdgeColor',c1,'FaceAlpha',0.0);
h1.DisplayStyle = 'stairs';
hold on;

PD2 = subangle2carangle(Sample.PD(5,:))/180*3.1415926;
h2 = polarhistogram(PD2,bins,'LineWidth',2,...
    'Normalization','probability','EdgeColor',c2,'FaceAlpha',0.0);
h2.DisplayStyle = 'stairs';
hold on;


h3 = polarhistogram(PD1,bins,...
    'FaceAlpha',0.2,'EdgeColor','None',...
    'Normalization','probability','FaceColor',c1);hold on;

h4 = polarhistogram(PD2,bins,...
    'FaceAlpha',0.2,'EdgeColor','None',...
    'Normalization','probability','FaceColor',c2);hold on;
set(f1,'Position',[10 10 310 310]);
