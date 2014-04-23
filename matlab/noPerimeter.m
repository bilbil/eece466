function[result] = noPerimeter(I)

%fill entire brain region with white pixels
BW = im2bw(I,0.1);
BW = bwperim(BW);
SE1 = strel('line', 6, 90);
SE2 = strel('line', 6, 0);
BW = imdilate(BW,[SE1 SE2]);
BW = imfill(BW,'holes');
% subplot(1,2,1);
% imshow(BW);

filterSize = 36;
V = floor(filterSize/2);

h = fspecial('gaussian',[filterSize,filterSize],32);
K = conv2(h,double(BW));
% imshow(K);


thresholdValue = 0.99;
K = K > thresholdValue;

for n =V:1:size(K,1)-V
    for n2=V:1:size(K,2)-V
    K2(n-V+1,n2-V+1) = K(n,n2);
    end
end
    
% subplot(1,2,2);
% imshow(K2);

result = K2;