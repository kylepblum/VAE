close all
clear all
load ../../Result/EXPResult.mat
y = X(1,:);
x = [10:10:180];
f = fit(x',y','exp1');

[~,gof] = fit(x',y','exp1');
exp1 = gof.rsquare;

[~,gof] = fit(x',y','exp2');
exp2 = gof.rsquare;

[~,gof] = fit(x',y','poly1');
poly1 = gof.rsquare;

[~,gof] = fit(x',y','poly2');
poly2 = gof.rsquare;

[f,gof] = fit(x',y','gauss1');
gauss1 = gof.rsquare;

[~,gof] = fit(x',y','power1');
power1 = gof.rsquare;

[~,gof] = fit(x',y','sin1');
sin1 = gof.rsquare;
