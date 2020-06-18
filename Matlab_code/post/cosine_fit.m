load ../../Result/rates.mat
r1 = squeeze(R(:,2,:));
r2 = squeeze(R(:,5,:));
pi = 3.1415626;
x = [1:360]/180*pi;

ft = fittype('a*cos(x+b)+c');
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.StartPoint =[1,0,1];


for i = 1:6400
    disp(i);
    y = r1(:,i);
    [f,gof] = fit(x',y,ft, opts);
    R2_1(i) = gof.rsquare;
    
    y = r2(:,i);
    [f,gof] = fit(x',y,ft, opts);
    R2_2(i) = gof.rsquare;
    
end
    