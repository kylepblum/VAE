load ../../Result/rates_new.mat

PD = zeros(10,6400);
PR = zeros(10,6400);
for i = 1:10
    for j = 1:6400
        [a,b] = max(X(:,i,j));
        PD(i,j) = b;
        PR(i,j) = a;
    end
end

Sample.PD = PD;
Sample.PR = PR;

[Sample.PDdiff, fit_result] = get_PDdiff(Sample.PD(5,:));
save('Sample.mat','Sample');