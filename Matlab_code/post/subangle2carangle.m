function [carangle] = subangle2carangle(subangle)
carangle = -subangle-73;
carangle(find(carangle>360)) = carangle(find(carangle>360))-360;
carangle(find(carangle<1)) = carangle(find(carangle<1))+360;
carangle(find(carangle<1)) = carangle(find(carangle<1))+360;
end

