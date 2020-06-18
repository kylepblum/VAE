X = csvread('../../Dataset/dataset.csv');
X = X(1:10:end,:);
X = X.^2;
XX = X./repmat(sum(X,2),[1,9]);
s = sum(XX(:,1:3)');
e = sum(XX(:,4:6)');
w = sum(XX(:,7:9)');

[x,y] = To_Triangle(s,e,w);

plot(x,y,'.');




