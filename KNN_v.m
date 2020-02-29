function label=KNN_v(training,K)
[row,column]=size(training);
for i=1:row
    temp=training;
    temp(i,:)=[];
    label(i)=KNN(temp,training(i,1:column-1),2,K);
end