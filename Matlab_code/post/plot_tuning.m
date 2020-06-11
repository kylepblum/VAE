load ../../Result/rates_new.mat
%[1,10,35]
x_sub = carangle2subangle([1:360]);
R_sample = X(:,:,1:100);
h1 = figure;
axes1 = subplot(1,1,1); 
plot(squeeze(R_sample(x_sub,2,32)), 'LineWidth', 2);hold on
plot(squeeze(R_sample(x_sub,5,32)), 'LineWidth', 2);

tmp = squeeze(R_sample(x_sub,2,32));
disp('1-low');disp(max(tmp));disp(find(tmp==max(tmp)));
tmp = squeeze(R_sample(x_sub,5,32));
disp('1-high');disp(max(tmp));disp(find(tmp==max(tmp)));

xlim([1,370]);
ylim([-1,40]);
set(axes1,'FontSize',14);
set(h1,'Position',[10 10 410 310])

% 22,45,59
h2 = figure;
axes1 = subplot(1,1,1); 
plot(squeeze(R_sample(x_sub,2,45)), 'LineWidth', 2);hold on;
plot(squeeze(R_sample(x_sub,5,45)), 'LineWidth', 2);

tmp = squeeze(R_sample(x_sub,2,45));
disp('2-low');disp(max(tmp));disp(find(tmp==max(tmp)));
tmp = squeeze(R_sample(x_sub,5,45));
disp('2-high');disp(max(tmp));disp(find(tmp==max(tmp)));


xlim([1,370]);
ylim([-1,40]);
set(axes1,'FontSize',14);
set(h2,'Position',[10 10 410 310])
    

h3 = figure;
axes1 = subplot(1,1,1); 
plot(squeeze(R_sample(x_sub,2,37)), 'LineWidth', 2);hold on;
plot(squeeze(R_sample(x_sub,5,37)), 'LineWidth', 2);

tmp = squeeze(R_sample(x_sub,2,37));
disp('3-low');disp(max(tmp));disp(find(tmp==max(tmp)));
tmp = squeeze(R_sample(x_sub,5,37));
disp('3-high');disp(max(tmp));disp(find(tmp==max(tmp)));


xlim([1,370]);
ylim([-1,40]);
set(axes1,'FontSize',14);
set(h3,'Position',[10 10 410 310])
    
    