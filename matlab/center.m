function [result] = center(input)

I = mat2gray(input);

meanx = 0;
meany = 0;
Zmax = 1;

[meanx,meany] = ait_centroid(I);

pictureWidth = size(I,2);
pictureXCenter = floor(size(I,2)/2);

pictureHeight = size(I,1);
pictureYCenter = floor(size(I,1)/2);

shiftX = pictureXCenter - floor(meanx);
shiftY = pictureYCenter - floor(meany);

shift = zeros(pictureHeight,pictureWidth,Zmax);

%shift entire image so centroid is in center of image
for countY = 1:1:pictureHeight
    for countX = 1:1:pictureWidth
        for countZ = 1:1:Zmax
            if (((countY-shiftY) >= 1) && ((countY-shiftY) <= pictureHeight))
                if (((countX-shiftX) >= 1) && ((countX-shiftX) <= pictureWidth))
                  shift(countY,countX,countZ) = I(countY-shiftY,countX-shiftX,countZ);
                end
            end
        end
    end
end

result = shift;
