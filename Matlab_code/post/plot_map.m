load ../../Result/PDResult_new.mat
load ../../Result/EXPResult.mat

% sigma = {'1_6','1_8','2','2_2'};

argmax = Result(2,9).PD;
n = length(argmax);
size = sqrt(n);
h = figure;
imagesc(reshape(argmax,[size,size]));colormap('hsv');
set(h,'Position',[10 10 310 310]);