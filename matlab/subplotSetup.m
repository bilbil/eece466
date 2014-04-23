function [imgXnum, imgYnum, currentImg] = subplotSetup(X,Y,ImgNumber,Img)
    
    currentImg = ImgNumber + 1;
    imgXnum = X;
    imgYnum = Y;
    
    subplot(imgYnum,imgXnum,currentImg);
    imshow(Img);
