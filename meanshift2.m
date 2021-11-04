%function Y = Meanshift(img, length)

clear,close
%img = imread('./3_.bmp');
%B=im2bw(img, 0.378);%对图像二值化

img = imread('./1_.bmp');
thresh=graythresh(img);%确定二值化阈值
B=im2bw(img, thresh);%对图像二值化




imshow(B)

RES=code_meanshift(B); % 生成类

figure(2)

for i = 1:length(RES)
    rule=RES{i};
    if (isempty(rule))
       continue; 
    end
    
    im=B(rule(3):rule(4),rule(1):rule(2));
    
    imshow(im)
    
    %scoreInductance(im)
    
    pause
end
