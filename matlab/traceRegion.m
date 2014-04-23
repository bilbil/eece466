funtion[result] = traceRegion(I,original,BWThreshold)

J = I;
B = original;

outline = bwperim(im2bw(J,BWThreshold));
% imshow(outline);

lineSize = 0.005*min(size(B,1),size(B,2));

SE1 = strel('line', lineSize, 90);
SE2 = strel('line', lineSize, 0);
outline = imdilate(outline,[SE1 SE2]);
% imshow(outline);

Z = gray2rgb(B*255);
%imshow(Z);

Z = zeros(size(Z,1),size(Z,2)),3);

for n = 1:1:size(Z,1)
    for n2 = 1:1:size(Z,2)
         Z(n,n2,2) = Z(n,n2,1) + 255*outline(n,n2);
         Z(n,n2,1) = Z(n,n2,1) - 255*outline(n,n2);
         Z(n,n2,3) = Z(n,n2,1) - 255*outline(n,n2);
    end
end

result = Z;
