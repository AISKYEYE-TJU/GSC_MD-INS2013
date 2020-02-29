
%% KNN
% generate the classification result on each fold first
clear
load data_ins 
fold=10;
base_classifier='KNN';
varargin=1;
[resultt,resultl,Label,testl]=generate_result(iono,fold,base_classifier,varargin);
 
% adaptive granularity selection and combination 
lambda=0.1;
contraint='non';
for k=1:10
  acc_mean(k)=sparse_classifier_l1w(lambda,resultt{k},resultl{k},Label{k},testl{k},contraint);
end
result=[mean(acc_mean)]
%mean(acc_mean) is the accuracy of granulairty combination 

%% NEC
% % generate the classification result on each fold first
% clear
% load data 
% fold=10;
% base_classifier='NEC';
% varargin=1;
% [resultt,resultl,Label,testl]=generate_result(heart,fold,base_classifier,varargin);
%  
% % adaptive granularity selection and combination 
% lambda=0.1;
% contraint='non';
% for k=1:10
%   acc_mean(k)=sparse_classifier_l1w(lambda,resultt{k},resultl{k},Label{k},testl{k},contraint);
% end
% result=[mean(acc_mean)]
% %mean(acc_mean) is the accuracy of granulairty combination 