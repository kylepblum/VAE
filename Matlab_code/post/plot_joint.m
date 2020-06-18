clear;
load ../../Result/rates_joint.mat
W = csvread('../../Result/weights140.csv');
v = [11.367 24.046 27.795 25.316 61.763 53.013 19.551 13.133 29.533];
bins = [0:0.5:50];
for i = 1:9
    counts = histcounts(X(i,:),bins)/6400;
    c(i) = sum(counts(2:end));
%     plot(counts(2:end));hold on; 
    x = bins(2:end-1);
    y = counts(2:end);
    f = fit(x',y','gauss1');
    coef = coeffvalues(f);
%     r(i) = coef(1);
%     a(i) = coef(2);
    b(i) =coef(3);

end
wsum = sum(abs(W'));
 plot(sqrt(v),wsum,'.');hold on
%  plot(v,wsum,'.');

% XX = abs(W);
% s = sum(XX);
% a = [];
% a(1,:) = sum(XX(1:3,:))./s;
% a(2,:) = sum(XX(4:6,:))./s;
% a(3,:) = sum(XX(7:9,:))./s;
% 
% t1 = [0,1];
% t2 = [-sqrt(3)/2, -0.5];
% t3 = [sqrt(3)/2, -0.5];
% pos = [];
% for i = 1:6400
%     pos(:,i) = t1*a(1,i)+t2*a(2,i)+t3*(a(3,i));
% end
% 
% plot(pos(1,:),pos(2,:),'.');