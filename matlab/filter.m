function [result] = filter(input)

imgXnum = 3;
imgYnum = 3;
currentImg = 0;

I = input;

if size(I,3) > 1
    J = rgb2gray(I);
else
    J = I; 
end

J = imadjust(J);

%[imgXnum,imgYnum,currentImg] = subplotSetup(imgXnum,imgYnum,currentImg,J);

thresholdValue = 200;
B = J > thresholdValue;
D = imfill(B, 'holes');
D = B;

%[imgXnum,imgYnum,currentImg] = subplotSetup(imgXnum,imgYnum,currentImg,D);

% G = fft2(D);
% h = fspecial('gaussian',[15,15],5);
% K = conv2(h,double(D));
% 
% currentImg = currentImg + 1;
% subplot(imgXnum,imgYnum,currentImg);
% imshow(K);
K = zeros(size(D,1),size(D,2));
K = D;
Fk = fftshift(fft2(K));

%[imgXnum,imgYnum,currentImg] = subplotSetup(imgXnum,imgYnum,currentImg,Fk);

circleFiltSizeX = size(Fk,1);
circleFiltSizeY = size(Fk,2);

h2 = zeros(circleFiltSizeX, circleFiltSizeY);
%imshow(h2);

midpoint1 = floor(circleFiltSizeX/2);
midpoint2 = floor(circleFiltSizeY/2);

passRadius1 =  midpoint1*4/10;

for count = 1:1:size(Fk,1)
   for count2 = 1:1:size(Fk,2)
       radius = sqrt((abs(count-midpoint1))^2 + (abs(count2-midpoint2))^2);
       if radius < passRadius1
           h2( count, count2) = 1*(1 - (radius/passRadius1))^2;
       end
   end
end

%[imgXnum,imgYnum,currentImg] = subplotSetup(imgXnum,imgYnum,currentImg,h2);
Fy = h2.*Fk;

%[imgXnum,imgYnum,currentImg] = subplotSetup(imgXnum,imgYnum,currentImg,Fy);

y = ifft2(ifftshift(Fy));

%[imgXnum,imgYnum,currentImg] = subplotSetup(imgXnum,imgYnum,currentImg,y);

result = real(y);

%------------------------------------------------------------

% U = entropyfilt(real(y));
% imshow(U,[]);
% 
% outline = bwperim(y);
% 
% SE3 = strel('line', 3, 90);
% SE4 = strel('line', 3, 0);
% X = imdilate(outline,[SE3 SE4]);
% imshow(X);
% 
% ----------------- add to original image
% 
% Segout = I;
% Segout(outline) = 255;
% figure, imshow(Segout);
% 
% imshow(Z);
