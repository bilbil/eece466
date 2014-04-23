function[] = main(fileName)

% clear;
% fileName = 'tumor6.jpg';

T = imread(fileName);

maxDimension = max(size(T,1), size(T,2));
if maxDimension > 750
    scaleFactor = maxDimension/750;
    T = imresize(T, 1/scaleFactor);
end

if size(T,3) > 1
    T = rgb2gray(T);
else
    T = T; 
end

imshow(T);
title('Original Image');
% pause(3);
% k = waitforbuttonpress;

T = imadjust(T);

D = mat2gray(center(T));
imshow(D);
title('Centered...');
% pause(3);
% k = waitforbuttonpress;

rotateDiv = 2;
rotateCount = 180/rotateDiv;

Hprev = 0;
Hindex = 1; 

Hcur = zeros(rotateCount);

for n = 1:1:rotateCount
     B = imrotate(D,(n-1)*rotateDiv);
     Hcur(n) = correlate(B);
     if Hcur(n) > Hprev
        Hprev = Hcur(n);
        Hindex = n; 
     end
     pause(0.05);
end

angleArray = [0:rotateDiv:180 - rotateDiv];
plot(angleArray, Hcur);
ylabel('Cross Correlation Sum');
xlabel('Angle of Rotation');
title('Plot of Cross Correlation');
hold on;
plot((Hindex-1)*rotateDiv,Hcur(Hindex),'r*');
text((Hindex-1)*rotateDiv,Hcur(Hindex),'Maximum Correlation','FontSize',16);
hold off;
pause(3);
k = waitforbuttonpress;

B = imrotate(D,(Hindex-1)*rotateDiv);
B = mat2gray(B);
imshow(B);
title('Rotated...');
% pause(3);
% k = waitforbuttonpress;

G = myfilter(B,30,0.6);
G = mat2gray(G);
imshow(G);
title('Noise and Threshold Filtered...');
% pause(3);
% k = waitforbuttonpress;


% thresholdValue = 0.6;
% K2 = B < thresholdValue;
% K3 = B - K2;
% 
% imshow(K3);
% title('Threshold before Blur');
% k = waitforbuttonpress;

filterSize = 20;
V = floor(filterSize/2);

h = fspecial('gaussian',[filterSize,filterSize],28);
K = conv2(h,double(B));

for n =V:1:size(K,1)-V
    for n2=V:1:size(K,2)-V
    U(n-V+1,n2-V+1) = K(n,n2);
    end
end


% U = myfilter(B,15,0.4);
% U = mat2gray(U);
imshow(U);
title('Blur Filtered before Asymmetric Mask...');
% % pause(3);
% k = waitforbuttonpress;

H = mirror(U);
imshow(H);
title('Asymmetric Mask...');
% pause(3);
% k = waitforbuttonpress;

J = immultiply(G,H);
imshow(J);
title('After Asymmetric Filtering...');
% pause(3);
% k = waitforbuttonpress;

K = noPerimeter(B);
K = mat2gray(K);
imshow(K);
title('Perimeter Mask...');
% pause(3);
% k = waitforbuttonpress;

J = immultiply(J,K);
imshow(J);
title('After Perimeter Filtering...');
% pause(3);
% k = waitforbuttonpress;

% result = J;
% original = B;

imwrite(J,strcat('R_',fileName),'jpg');
imwrite(B,strcat('O_',fileName),'jpg');


