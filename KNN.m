function   label=KNN(training,testS,D,k);
%KNN classifiers, 
%training is training set, testing is test set, 
%D is the  distance, D=1 is mandistance; D=2 is Å·ÊÏ¾àÀë D=3ÊÇ infinite norm
% K is the number of selected neighbors
[row, column]=size(training);
[row1, column1]=size(testS);
%¼ÆËã²âÊÔ¼¯ÓëÑµÁ·¼¯µÄ¾àÀë
distance=[];
switch D
    case {1}
        for i=1:row1
            distance(i,:)=sum(abs(repmat(testS(i,1:(column-1)),row,1)-training(:,1:(column-1))), 2);  
        end
    case {2}
        for i=1:row1
            distance(i,:)=sum((repmat(testS(i,1:(column-1)),row,1)-training(:,1:(column-1))).^2, 2);
        end
    case {3}
        for i=1:row1
            distance(i,:)=max(abs(repmat(testS(i,1:(column-1)),row,1)-training(:,1:(column-1))), 2); 
        end
    case {4}
         g=0.6;
         for i=1:row1
             for j=1:row
             distance(i,j)= (sum((abs(testS(i,1:(column-1))-training(j,1:(column-1)))).^g)).^(1/g);
             end
        end
    case {5}
          for i=1:row1
           for j=1:row
              q=[];
              for l=1:(column-1)
                 if max(training(:,l))>1
                  if  testS(i,l)==training(j,l);
                    q(l)=0;
                else
                     q(l)=1;
                   end
                 else 
                q(l)=testS(i,l)-training(j,l);
                end
             end
          distance(i,j)=sum(q.^2);
           end
          end 
end
% Ñ°ÕÒk¸ö½üÁÚ
label=[];
for i=1:row1
    [a,b]=sort(distance(i,:));
    neighbors=b(1:k)';
    neighbors_D=training(neighbors,column);
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

        
