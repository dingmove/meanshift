%function Y = Meanshift(img, length)

clear,close
%img = imread('./3_.bmp');
%B=im2bw(img, 0.378);%��ͼ���ֵ��

img = imread('./1_.bmp');
thresh=graythresh(img);%ȷ����ֵ����ֵ
B=im2bw(img, thresh);%��ͼ���ֵ��




imshow(B)

RES=code_meanshift(B); % ������

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
