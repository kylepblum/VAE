load('pca_planar.mat');
load('pca_natural.mat');

D = 9;
vaf = v_natural/sum(v_natural);
vaf = variance/sum(variance);
tmp = 0;
for j = 1:D
    for i = 1:j
        tmp = tmp + vaf(i)-1/D;
    end
end

C = 1-2/(D-1)*tmp;
