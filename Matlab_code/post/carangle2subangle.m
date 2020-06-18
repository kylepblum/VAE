function [subangle] = carangle2subangle(carangle)
subangle = -carangle-73;
subangle(find(subangle>360)) = subangle(find(subangle>360))-360;
subangle(find(subangle<1)) = subangle(find(subangle<1))+360;
subangle(find(subangle<1)) = subangle(find(subangle<1))+360;
end



