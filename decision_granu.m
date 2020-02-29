function  [result_t,result_l,lab_t,lab_l]=decision_granu(training,testS,testL,n,method)

% generate  the classification result on one fold
[row,col]=size(training);
Samples=training(:,1:col-1);
Labels=training(:,col);
result_t=[];
result_l=[];
delta=0.06:0.02:0.3;
k_d=1:2:13;
for N=1:n
    del=delta(N);
    K=k_d(N);
 switch method
             case 'KNN' %KNN classifier
            training=[Samples,Labels];
%             feature_slct=NRS_random_FW_FS(training,del,0.001,1); %find the feature subspace 
            label_t=KNN_v(training,K);
            label_l=KNN(training,testS,2,K);            
              case 'NEC' %CART classifier       
            label_t=NEC_v(training,del);
            label_l=NEC(training,testS,2,del);
 end
result_l=[result_l,label_l'];
result_t=[result_t,label_t'];  
end
lab_t=Labels;
lab_l=testL;