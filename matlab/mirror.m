function [result] = mirror(input)

I = input;

pictureWidth = size(I,2);
pictureCenter = floor(size(I,2)/2);

Zmax = 1;
Xmax = pictureCenter;
Ymax = size(I,1);

leftHalf = zeros(Ymax,Xmax,Zmax);

%copy left side of image
for countY = 1:1:Ymax
    for countX = 1:1:Xmax
        for countZ = 1:1:Zmax
            leftHalf(countY,countX,countZ) = I(countY,countX,countZ);
        end
    end
end

%imshow(leftHalf);

rightHalf = zeros(Ymax,Xmax,Zmax);

%copy right side of image
for countY = 1:1:Ymax
    for countX = 1:1:Xmax
        for countZ = 1:1:Zmax
            rightHalf(countY,countX,countZ) = I(countY,pictureCenter+countX,countZ);
        end
    end
end

%imshow(rightHalf);

reflectLeft = zeros(Ymax,Xmax,Zmax);

% reflect it horizontally
for countY = 1:1:Ymax
    for countX = 1:1:Xmax
        for countZ = 1:1:Zmax
            reflectLeft(countY,countX,countZ) = leftHalf (countY,Xmax - countX +1,countZ);
        end
    end
end

%imshow(reflectLeft);

%subtract right-left -> right
subTractRight = imsubtract(rightHalf,reflectLeft);
%imshow(subTractRight);

%subtract left - right -> left
subTractLeft = imsubtract(reflectLeft,rightHalf);
%imshow(subTractLeft);

reflectBacktoLeft = zeros(Ymax,Xmax,Zmax);

% reflect it back to left side
for countY = 1:1:Ymax
    for countX = 1:1:Xmax
        for countZ = 1:1:Zmax
            reflectBacktoLeft(countY,countX,countZ) = subTractLeft (countY,Xmax - countX +1,countZ);
        end
    end
end

%imshow(reflectBacktoLeft);


%subplot(1,2,1);
%imshow(I);

%subplot(1,2,2);
%concatenate the subtracted left and right images
%final image has size dimension as the input image
if (size(reflectBacktoLeft,2) + size (subTractRight,2)) < pictureWidth
    leftOverWidth = pictureWidth - 2 * Xmax;
    leftOverMatrix = zeros(Ymax, leftOverWidth ,Zmax);
    if Xmax <= pictureCenter
        subtractConcat = [reflectBacktoLeft,subTractRight,leftOverMatrix];
    else
        subtractConcat = [leftOverMatrix,reflectBacktoLeft,subTractRight];
    end
else
    subtractConcat = [reflectBacktoLeft,subTractRight];
end
%imshow(subtractConcat);

result = real(subtractConcat);