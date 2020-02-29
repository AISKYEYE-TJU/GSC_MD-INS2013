%neighborhood classifiers, 
%training is training set, testing is test set, 
%D is paramater to select the  distance function, D=1 is mandistance; D=2 is 欧氏距离 D=3是 infinite norm
% T is used to control the size of neighborhood
function label=NEC(training,testing,D,w)
[row, column]=size(training);
[row1, column1]=size(testing);
%数据标准化
Tr_m=min(training);
Tr_s=max(training);
Tr=[];
Te=[];
for i=1:(column-1)
    Tr_mi=(training(:,i)-Tr_m(i))/Tr_s(i);
    Te_mi=(testing(:,i)-Tr_m(i))/Tr_s(i);
    Tr=[Tr,Tr_mi];
    Te=[Te,Te_mi];
end
training=[Tr,training(:,column)];
testing=Te;

%计算测试集与训练集的距离
distance=[];
switch D
    case {1}
   for i=1:row1
        for j=1:row
            temp=[training(j,[1:(column-1)]);testing(i,:)]';
            d=mandist(temp);
            distance(i,j)=d(1,2);
        end
    end
    case {2}
        for i=1:row1
            for j=1:row
                temp=[training(j,[1:(column-1)]);testing(i,:)]';
                d=dist(temp);
                distance(i,j)=d(1,2);
            end
        end
    case {3}
        for i=1:row1
            for j=1:row
                temp=[training(j,[1:(column-1)]);testing(i,:)];
                d=max(abs(temp(1,:)-temp(2,:)));
                distance(i,j)=d;
            end
        end
end
% 寻找邻域内样本
label=[];
for i=1:row1
    T=min(distance(i,:))+w*range(distance(i,:));
    [a,b]=find(distance(i,:)<=T);
    neighbors=b;
    neighbors_D=training(b,column);
    [x,y]=sort(neighbors_D);
    temp=find(diff(x)~=0);        
    nei_d=[x(1);x(temp+1)];
    Num_D=[];
    for j=1:length(nei_d)
        num=length(find(neighbors_D==nei_d(j)));
        Num_D=[Num_D,num];
    end
    [a,b]=max(Num_D);
    label(i)=nei_d(b);
end