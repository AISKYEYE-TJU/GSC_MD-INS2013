function label=NEC_v(training,del)
[row,column]=size(training);
for i=1:row
    temp=training;
    temp(i,:)=[];
    label(i)=NEC(temp,training(i,1:column-1),2,del);
end