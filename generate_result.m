function  [resultt,resultl, Label,testl]=generate_result(data,fold,method,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%data is all data with decision
%fold is the number of folds in cross validation
%base_classifier is the flag to specify the classification algorithm. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%addpath 'D:\Program Files\MATLAB\R2008a\work\osu_svm3.00'
N=length(varargin);
if N>0
    switch N
        case {1}
            k=cell2mat(varargin(1));
            Gamma=cell2mat(varargin(1));
            q=cell2mat(varargin(1));
        case {2}
            delta=cell2mat(varargin(1,1));
            pct=cell2mat(varargin(1,2));
            Gamma=cell2mat(varargin(1,1));
            dell=cell2mat(varargin(1,2));
        case {3}
            k=cell2mat(varargin(1));
            delta=cell2mat(varargin(1,2));
            pct=cell2mat(varargin(1,3));
    end
end
[row column]=size(data);
for i=1:column-1
    data(:,i)=(data(:,i)-min(data(:,i)))/(max(data(:,i))-min(data(:,i)));
end

label=data(:,column);
classnum=max(label);
start1=1;
for i=1:classnum
    [a,b]=find(label==i);
    datai=data(a,:);      %select the i class data 
    [rr1,cc1]=size(datai);
    start1=1;
    %%%%%%%%%part the i class in (fold)%%%%%%%%%%%%%%%%%%%%%
    for j=1:fold-1
        a1=round(length(a)/fold);
        a2=a1-1;
        %fun1=strcat('x*',num2str(a1),'+y*',num2str(a2),'=',num2str(rr1)); 
        %fun2=strcat('x+y=',num2str(fold)); 
        %[x,y]=solve(fun1,fun2) 
        %[x,y] = solve('x*a1+a2*y=rr1','x+y=fold')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        A=[a1 a2;1 1];
        b=[rr1 fold]';
        x=A\b;
        if (j<x(1)+1)
            everynum=a1;
        else
            everynum=a2;
        end
        start2=start1+everynum-1;       
        eval(['data' num2str(i) num2str(j) '=datai([start1:start2],:);']);
        start1=start2+1;
    end
    eval(['data' num2str(i) num2str(fold) '=datai([start1:length(a)],:);']);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:fold
    eval(['part' num2str(j) '=[];']);
    for i=1:classnum
      eval(['part' num2str(j) '=[part' num2str(j) ';data' num2str(i) num2str(j) '];']);
    end   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
confuse=zeros(classnum);
for j=1:fold
    Samples=[];
     Labels=[];
     testS=[];
     testL=[];
    for i=1:fold
        
        if (i~=j)
            eval(['Samples=[Samples;part' num2str(i) '(:,1:column-1)];'])
            eval(['Labels=[Labels;part' num2str(i) '(:,column)];'])
        end
    end
    eval(['testS=part' num2str(j) '(:,1:column-1);'])
    eval(['testL=part' num2str(j) '(:,column);'])
           training=[Samples,Labels];
          [result_t,result_l]=decision_granu(training,testS, testL,7,method); % generate the classification result of one fold 
           resultl{j}=result_l;     % save the result of one fold (test)
           resultt{j}=result_t;     % save the result of one fold (training)
           Label{j}= Labels;
           testl{j}= testL;
end
end
