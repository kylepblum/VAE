function [PDdiff, fit_result] = get_PDdiff(PD)
n = length(PD);
size = sqrt(n);

PD =reshape(PD,[size,size]);
PD = PD(11:size-10, 11:size-10);
PD = reshape(PD, [1,(size-20)^2]);
size = size-20;
[locx,locy] = meshgrid(1:size,1:size);
loc(:,1) = reshape(locx,[],1);
loc(:,2) = reshape(locy,[],1);
D = pdist(loc);
D = squareform(D);
D = reshape(D,[],1);
EDGES = [0:10:170,179];
dif = repmat(PD,[size^2,1]) - repmat(PD', [1,size^2]); 
dif = reshape(dif, [],1);
dif(find(dif>=180)) = dif(find(dif>=180))-360;
dif(find(dif<-180)) = dif(find(dif<-180))+360;
dif = abs(dif);

near = find(D<=1 & D>0);
[Nnear,EDGES] = histcounts(dif(near),EDGES);

far = find(D>8);
[Nfar,EDGES] = histcounts(dif(far),EDGES);

all = find(D>0);
[Nall,EDGES] = histcounts(dif(all),EDGES);
barp = [Nnear/length(near); Nfar/length(far); Nall/length(all)];

x = [10:10:180]';
y = Nnear/length(near);
[f, gof] = fit(x,y','exp1');
PDdiff = barp;
fit_result.fitcoef = coeffvalues(f);
fit_result.R2 = gof.rsquare;



end

