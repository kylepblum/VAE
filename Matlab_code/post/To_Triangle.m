function [x,y] = To_Triangle(s,e,w)
a = [0,1];
b = [-sqrt(3)/2, -0.5];
c = [sqrt(3)/2, -0.5];

x = s.*a(1)+e.*b(1)+w.*c(1);
y =  s.*a(2)+e.*b(2)+w.*c(2);
end

