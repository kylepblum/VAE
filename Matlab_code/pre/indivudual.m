axes = subplot(1,1,1);

for i = [1:8,11:14,16:19]
X = csvread(['../../Dataset/trainS',int2str(i),'.csv']);
[a,b,v_natural] = pca(X);

variance_recovered_natural = cumsum(v_natural)/sum(v_natural);
plot(variance_recovered_natural);hold on;
end
save('pca_natural.mat','v_natural','a');
variance_recovered_natural = cumsum(v_natural)/sum(v_natural);
plot(variance_recovered_natural,'k','LineWidth',2);hold on;