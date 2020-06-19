load ../../Result/rates.mat
peakrate = zeros(10,6400);
for i = 1:10
    for j = 1:6400
        peakrate(i,j) = max(R(:,i,j))/40*1000;
    end
end
save('peakrate.mat','peakrate');