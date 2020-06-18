ft = fittype('a*exp(-b*x)+c');
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.StartPoint = [0.55870305634287 0.808037493359497 0.70576432051369];

load ../../Result/PDResult.mat
x = [10:10:180];
tmp = [];
for sigma = 1:4
    for seed = 1:9
    barp = Result(sigma,seed).PDdiff;
    y = barp(1,:);
    f = fit(x',y','exp1');
    Result(sigma,seed).fitcoef = coeffvalues(f);
%     tmp(sigma,seed) = Result(sigma,seed).fitcoef(3);
    end
end

save('../../Result/PDResult.mat','Result');