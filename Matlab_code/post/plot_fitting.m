load ../../Result/PDResult_new.mat
load ../../Result/EXPResult.mat
for sigma = 1:4
    coef = [];
    for seed = 1:10
        coef1(sigma,seed) = Result(sigma,seed).fitcoef(1);
        coef2(sigma,seed) = Result(sigma,seed).fitcoef(2);
    end
end

x = [10:10:180];
y = X(1,:);
f = fit(x',y','exp1');
expcoef = coeffvalues(f);


%% plot
h1 = figure;
set(h1,'Position',[10 10 810 310])
set(gca,'TickLabelInterpreter', 'tex');


% subplot 1
subplot1 = subplot(1,2,1);
hold(subplot1,'on');

name = ['\sigma = 1.6'];
plot(-coef2(1,:),coef1(1,:),'DisplayName',name,'MarkerSize',10,'Marker','+',...
    'LineWidth',2,...
    'LineStyle','none');

name = ['\sigma = 1.8'];
plot(-coef2(2,:),coef1(2,:),'DisplayName',name,'MarkerSize',10,'Marker','+',...
    'LineWidth',2,...
    'LineStyle','none');

name = ['\sigma = 2.0'];
plot(-coef2(3,:),coef1(3,:),'DisplayName',name,'MarkerSize',10,'Marker','+',...
    'LineWidth',2,...
    'LineStyle','none');


name = ['\sigma = 2.2'];
plot(-coef2(4,:),coef1(4,:),'DisplayName',name,'MarkerSize',10,'Marker','+',...
    'LineWidth',2,...
    'LineStyle','none');




plot(-expcoef(2),expcoef(1),'DisplayName','Recording','MarkerSize',15,'Marker','+',...
    'LineWidth',2,...
    'LineStyle','none',...
    'Color',[0 0 0]);

flinear = fit(-coef2(:),coef1(:),'poly1');
x = [0.01:0.001:0.027];
plot(x,flinear(x),'DisplayName','Fitting','LineWidth',1.5,...
    'Color',[0.3 0.3 0.3]);

ylim(subplot1,[0.1 0.3]);
xlim(subplot1,[0.008,0.028]);
box(subplot1,'on');
set(subplot1,'FontSize',14);
legend1 = legend(subplot1,'show');
set(legend1,...
    'Position',[0.330541578668803 0.543779537905686 0.134292545257141 0.374293782863454],...
    'FontSize',14,...
    'EdgeColor','none');


%subplot2
subplot2 = subplot(1,2,2);
m = mean(coef1');
s = std(coef1');
for i = 1:4
    plot(i, m(i),'k+','MarkerSize',10, 'LineWidth',2);hold on
    errorbar(i, m(i),s(i),'MarkerSize',10, 'LineWidth',2);hold on
end
ylim([0.1,0.3]);

% boxplot(coef1');hold on
plot([0,5],[expcoef(1),expcoef(1)],'k--', 'LineWidth',1.5);
set(subplot2,'FontSize',14);
set(subplot2,'XTick',[1 2 3 4],'XTickLabel',...
    {'\sigma = 1.6','\sigma =1.8','\sigma = 2.0','\sigma = 2.2'});