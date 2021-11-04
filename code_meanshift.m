function RES = code_meanshift(img)

%img = imread('./1_.bmp');
%thresh=graythresh(img);%ȷ����ֵ����ֵ
%img=im2bw(img, thresh);%��ͼ���ֵ��

[m0,n0] = size(img);
bw=ones(m0,n0);

[p1,p2] = find(img==0);
data=[p2,p1];

figure(1)
subplot(2,1,1)
%plot(p2,-p1,'*')
imshow(img)
axis on

%mean shift �㷨
[m,n]=size(data);
index=1:m;
radius=50; 
D_min =radius*0.75;  % ��С�ϲ�����

%stopthresh=1e-3*radius;

stopthresh=5;

visitflag=zeros(m,1);%����Ƿ񱻷���
count=[];
clustern=0;
clustercenter=[];

hold on;
while length(index)>0
    cn=ceil((length(index)-1e-6)*rand);%���ѡ��һ��δ����ǵĵ㣬��ΪԲ�ģ����о�ֵƯ�Ƶ���
    center=data(index(cn),:); % Բ������
    this_class=zeros(m,1);%ͳ��Ư�ƹ����У�ÿ����ķ���Ƶ��

    %% ��һ��������ƶ� ֱ���޷��ƶ�
    % ����2��3��4��5
    while 1
        %������뾶�ڵĵ㼯
        dis=sum((repmat(center,m,1)-data).^2,2);
        radius2=radius*radius;
        innerS=find(dis<radius*radius);    
        visitflag(innerS)=1;%�ھ�ֵƯ�ƹ����У���¼�Ѿ������ʹ��õ�     
        this_class(innerS)=this_class(innerS)+1; % �ѷ��ʴ�����һ
        %����Ư�ƹ�ʽ�������µ�Բ��λ��
        newcenter=zeros(1,2);
       % newcenter= mean(data(innerS,:),1); 
        sumweight=0;
        for i=1:length(innerS)
            w=exp(dis(innerS(i))/(radius*radius));
            sumweight=w+sumweight;
            newcenter=newcenter+w*data(innerS(i),:);
        end
        newcenter=newcenter./sumweight;
        if norm(newcenter-center) <stopthresh%����Ư�ƾ��룬���Ư�ƾ���С����ֵ����ôֹͣƯ��
            break;
        end
        center=newcenter;
        plot(center(1),center(2),'*y');
        % pause
    end
    
    %% ����6 �ж��Ƿ���Ҫ�ϲ����������Ҫ�����Ӿ������1��
    % ���μ����µľ������������ľ���
    mergewith=0;
    for i=1:clustern
        betw=norm(center-clustercenter(i,:));
        if betw<D_min
            mergewith=i; 
            break;
        end
    end
    
    if mergewith==0           %����Ҫ�ϲ�
        clustern=clustern+1;
        clustercenter(clustern,:)=center;
        count(:,clustern)=this_class;
    else                      %�ϲ�
        clustercenter(mergewith,:)=0.5*(clustercenter(mergewith,:)+center);
        count(:,mergewith)=count(:,mergewith)+this_class;  
    end
    
    %����ͳ��δ�����ʹ��ĵ�
    index=find(visitflag==0);
end%�����������ݵ����

clustern

%% �������
cVec = 'bgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmykbgrcmyk';
for k = 1:clustern
    plot(clustercenter(k,1),clustercenter(k,2),'o','MarkerEdgeColor','k','MarkerFaceColor',cVec(k), 'MarkerSize',10)
end

%% ���Ʒ�����
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


