load ../../Result/correlation.mat
X = csvread('../../Dataset/dataset.csv')';
X = X(:,1:10:end);


XX = abs(map);

 s = mean(XX(1:3,:));
e = mean(XX(4:6,:));
w = mean(XX(7:9,:));
p = [s*2,e*2,w*2]';
p = min(p,1);
I_rgb = reshape(p,[80,80,3]);
% I_cmyk(:,:,4) = 0;
% 
% inprof = iccread('USSheetfedCoated.icc');
% outprof = iccread('sRGB.icm');
% C = makecform('icc',inprof,outprof);
% I_rgb = applycform(I_cmyk,C);
% I_rgb = imresize(I_rgb,10,'nearest');
imshow(I_rgb);

% XX = abs(X).^2;
% 
% s = sqrt(sum(XX(1:3,:)));
% e = sqrt(sum(XX(4:6,:)));
% w = sqrt(sum(XX(7:9,:)));
% 
% m = s+e+w;
% s = s./m;
% e = e./m;
% w = w./m;
% 
% [x,y] = To_Triangle(s,e,w);
% 
% 
% plot(x,y,'.');hold on;
% plot([sqrt(3)/2,-sqrt(3)/2,0,sqrt(3)/2],[-0.5,-0.5,1,-0.5],'k');
% 


% for i = 1:9
%     h = subplot(3,3,i);
%     M = reshape(map(i,:),[80,80]);
%      M(find(abs(M)<0.1)) = 0;
%     imagesc(M);colormap('gray');
%     set(h,'XTick',[],'YTick',[]);
%     colorbar;
%     caxis manual
% caxis([-1 1]);
% end
% set(gcf,'Position',[10 10 610 610]);
%     