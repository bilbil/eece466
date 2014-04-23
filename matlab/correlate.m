function [result] = correlate(input)

I = mat2gray(input);

meanx = 0;
meany = 0;
Zmax = 1;

[meanx,meany] = ait_centroid(I);

pictureWidth = size(I,2);
pictureCenter = floor(size(I,2)/2);

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

rightHalf = zeros(Ymax,Xmax,Zmax);

%copy right side of image
for countY = 1:1:Ymax
    for countX = 1:1:Xmax
        for countZ = 1:1:Zmax
            rightHalf(countY,countX,countZ) = I(countY,floor(meanx)+ countX,countZ);
        end
    end
end

reflectLeft = zeros(Ymax,Xmax,Zmax);

% reflect it horizontally
for countY = 1:1:Ymax
    for countX = 1:1:Xmax
        for countZ = 1:1:Zmax
            reflectLeft(countY,countX,countZ) = leftHalf (countY,Xmax - countX +1,countZ);
        end
    end
end

%fill reflected left brain region with white pixels
BWreflectLeft = im2bw(reflectLeft,0.2);
% imshow(BWreflectLeft);
BWreflectLeft = bwperim(BWreflectLeft);
SE3 = strel('line', 11, 90);
SE4 = strel('line', 11, 0);
BWreflectLeft = imdilate(BWreflectLeft,[SE3 SE4]);
BWreflectLeft = imfill(BWreflectLeft,'holes');
% imshow(BWreflectLeft);

%fill right brain region with white pixels
BWrightHalf = im2bw(rightHalf,0.2);
BWrightHalf = bwperim(BWrightHalf);
SE1 = strel('line', 11, 90);
SE2 = strel('line', 11, 0);
BWrightHalf = imdilate(BWrightHalf,[SE1 SE2]);
BWrightHalf = imfill(BWrightHalf,'holes');
% imshow(BWrightHalf);


multiplyRight = immultiply(BWrightHalf,BWreflectLeft);
imshow(multiplyRight);
title('Cross Correlating Right and Mirrored Left side...');

result = sum(sum(multiplyRight));
