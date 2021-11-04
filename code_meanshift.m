function RES = code_meanshift(img)

%img = imread('./1_.bmp');
%thresh=graythresh(img);%确定二值化阈值
%img=im2bw(img, thresh);%对图像二值化

[m0,n0] = size(img);
bw=ones(m0,n0);

[p1,p2] = find(img==0);
data=[p2,p1];

figure(1)
subplot(2,1,1)
%plot(p2,-p1,'*')
imshow(img)
axis on

%mean shift 算法
[m,n]=size(data);
index=1:m;
radius=50; 
D_min =radius*0.75;  % 最小合并距离

%stopthresh=1e-3*radius;

stopthresh=5;

visitflag=zeros(m,1);%标记是否被访问
count=[];
clustern=0;
clustercenter=[];

hold on;
while length(index)>0
    cn=ceil((length(index)-1e-6)*rand);%随机选择一个未被标记的点，作为圆心，进行均值漂移迭代
    center=data(index(cn),:); % 圆心坐标
    this_class=zeros(m,1);%统计漂移过程中，每个点的访问频率

    %% 对一个点进行移动 直至无法移动
    % 步骤2、3、4、5
    while 1
        %计算球半径内的点集
        dis=sum((repmat(center,m,1)-data).^2,2);
        radius2=radius*radius;
        innerS=find(dis<radius*radius);    
        visitflag(innerS)=1;%在均值漂移过程中，记录已经被访问过得点     
        this_class(innerS)=this_class(innerS)+1; % 已访问次数加一
        %根据漂移公式，计算新的圆心位置
        newcenter=zeros(1,2);
       % newcenter= mean(data(innerS,:),1); 
        sumweight=0;
        for i=1:length(innerS)
            w=exp(dis(innerS(i))/(radius*radius));
            sumweight=w+sumweight;
            newcenter=newcenter+w*data(innerS(i),:);
        end
        newcenter=newcenter./sumweight;
        if norm(newcenter-center) <stopthresh%计算漂移距离，如果漂移距离小于阈值，那么停止漂移
            break;
        end
        center=newcenter;
        plot(center(1),center(2),'*y');
        % pause
    end
    
    %% 步骤6 判断是否需要合并，如果不需要则增加聚类个数1个
    % 依次计算新的聚类点与其他点的距离
    mergewith=0;
    for i=1:clustern
        betw=norm(center-clustercenter(i,:));
        if betw<D_min
            mergewith=i; 
            break;
        end
    end
    
    if mergewith==0           %不需要合并
        clustern=clustern+1;
        clustercenter(clustern,:)=center;
        count(:,clustern)=this_class;
    else                      %合并
        clustercenter(mergewith,:)=0.5*(clustercenter(mergewith,:)+center);
        count(:,mergewith)=count(:,mergewith)+this_class;  
    end
    
    %重新统计未被访问过的点
    index=find(visitflag==0);
end%结束所有数据点访问

clustern

%% 画聚类点
cVec = 'bgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmyk';
for k = 1:clustern
    plot(clustercenter(k,1),clustercenter(k,2),'o','MarkerEdgeColor','k','MarkerFaceColor',cVec(k), 'MarkerSize',10)
end

%% 绘制分类结果
for i=1:m
    [value index]=max(count(i,:));
    Idx(i)=index;
end
% % pause
% figure(2);
% 
subplot(2,1,2)
hold on;
imshow(bw);
for i = 1:clustern
    p = find(Idx == i);
    p1 = data(p,1);
    p2 = data(p,2);

    RES{i} = [min(p1),max(p1),min(p2),max(p2)];
    
     plot(p1,p2,'*','MarkerEdgeColor',cVec(i),'MarkerFaceColor',cVec(i))
     plot(clustercenter(i,1),clustercenter(i,2),'o','MarkerEdgeColor','m','MarkerFaceColor',cVec(k), 'MarkerSize',10)
%    pause
end


