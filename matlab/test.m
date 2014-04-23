function [] = test(I)
clear;

if size(I,3) > 1
    I = rgb2gray(I);
else
    I = I; 
end

%imshow(I);

meanx = 0;
meany = 0;
Zmax = 1;

[meanx,meany] = ait_centroid(I);

if floor(meanx) * 2 > size(I,2)  
    Xmax = size(I,2) - floor(meanx);
else
    Xmax = floor(meanx);
end

Ymax = size(I,1);

leftHalf = zeros(Ymax,Xmax,Zmax);

%copy left side of image
for countY = 1:1:Ymax
    for countX = 1:1:Xmax
        for countZ = 1:1:Zmax
            leftHalf(countY,countX,countZ) = I(countY,floor(meanx)- Xmax + countX,countZ);
        end
    end
end

leftHalf = uint8(leftHalf);
%imshow(leftHalf);

%copy right side of image
for countY = 1:1:Ymax
    for countX = 1:1:Xmax
        for countZ = 1:1:Zmax
            rightHalf(countY,countX,countZ) = I(countY,floor(meanx)+ countX,countZ);
        end
    end
end

rightHalf = uint8(rightHalf);
%imshow(rightHalf);

% reflect it horizontally
for countY = 1:1:Ymax
    for countX = 1:1:Xmax
        for countZ = 1:1:Zmax
            reflectLeft(countY,countX,countZ) = leftHalf (countY,Xmax - countX +1,countZ);
        end
    end
end

reflectLeft = uint8(reflectLeft);
%imshow(reflectLeft);

%imsubtract
subTractRight = imsubtract(rightHalf,reflectLeft);
%imshow(subTractRight);

subTractLeft = imsubtract(reflectLeft,rightHalf);
%imshow(subTractLeft);

% reflect it back to left side
for countY = 1:1:Ymax
    for countX = 1:1:Xmax
        for countZ = 1:1:Zmax
            reflectBacktoLeft(countY,countX,countZ) = subTractLeft (countY,Xmax - countX +1,countZ);
        end
    end
end

%imshow(reflectBacktoLeft);


subplot(1,2,1);
imshow(I);

subplot(1,2,2);
%concatenate the subtracted left and right images
subtractConcat = [reflectBacktoLeft,subTractRight];
imshow(subtractConcat);

