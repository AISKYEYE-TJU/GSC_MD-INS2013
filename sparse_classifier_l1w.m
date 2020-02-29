function [acc_mean,acc_sum]=sparse_classifier_l1w(lambda,resultt,resultl,Label,testl,contraint)

[row1,n]=size(resultt);% the number of training samples
[row2,n]=size(resultl);% the number of test samples
index=unique(Label); 
D=ones(row1,n);% the decision matrix
for i=1:n
   D(resultt(:,i)~=Label,i)=-1;
end
D1=[D;ones(1,n)];

limit='non';
w0=ones(n,1)/n;

X=ones(row1,1);
X1=ones(row1+1,1);
% learn the weight of the base classifiers
      if strcmp(contraint,limit)
       w = l1_ls(D1, X1, lambda*row1); %learn the sparse cofficents
      else
       z=lambda;
      opts.rFlag=0;
      opts.x0=w0;
      opts.rsL2=0;
      w=nnLeastC(D, X, z, opts);   %learn the sparse cofficents
      end
      
%  sort the classifiers according to the weights    
%       w=w/sum(w);
%       w1=abs(w)/sum(w);
     [value,c_d]=sort(-w);                     %the weight of the classifiers
      
for mm=1:n
     wei=w(c_d(1:mm));
     resultl1=[];
     resultl1=resultl(:,c_d(1:mm));
      for k=1:row2
        class=zeros(1,length(index));
        for pp=1:length(index)
         result_index=[];
         result_index=find(resultl1(k,:)==index(pp));
         class(pp)=sum(wei(resultl1(k,:)==index(pp)));  %
        end
        [w11,w22]=max(class);
        lab(k)=index(w22);
      end
       ClassRate(mm)=length(find((lab'-testl)==0))/row2;
end
[acc_mean,num]=max(ClassRate); 
acc_sum=ClassRate(n);