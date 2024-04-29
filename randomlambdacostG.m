function [L,C] = randomlambdacostG(cust,costset,lambdaset)
L = randi([5,50],lambdaset,cust)+rand([lambdaset cust]);%Lambda Set
c = zeros(costset,3*cust);%Generating cost set all zeros
costs=zeros(costset,3*cust);
for i=1:costset
    c(i,1:2:(2*cust)-1) = c(i,1:2:(2*cust)-1) + sort(randi([5 50],1,cust) + rand([1 cust]));
    difs = sort(randi(50,1,cust) + rand([1 cust]));
    c(i,2:2:(2*cust)) = c(i,1:2:(2*cust)-1) + difs;
    costs(i,:) = [-1*c(i,1:2*cust),difs];
end
C = costs;
%------------------- Usig already exist sets ------------------------------
L = xlsread('Customer5-Costset10-Lambdatset10.xlsx',1,'B2:F11');
C = xlsread('Customer5-Costset10-Lambdatset10.xlsx',2,'B2:P11');
% % C = C(:,[1:8,10:13]);
%----------- Recording the randomly generated Cost and Lambdas-------------
M0 = strcat('Customer',num2str(cust),'-Costset',num2str(costset),'-Lambdatset',num2str(lambdaset),'.xlsx');
H_two=[];
for i=1:cust
    lamlabel{i} = strcat('Lambda',num2str(i));
    c1_label{i} = strcat('C',num2str(i),'1');
    c2_label{i} = strcat('C',num2str(i),'2');
    d_label{i} = strcat('Dif',num2str(i));
    H_two = [H_two,{c1_label{i}(1,:),c2_label{i}(1,:)}];
end
H_one = strcat(lamlabel);
H_two = [H_two,d_label];
xlswrite(M0,{'Number',H_one{1,:}},1,'A1');
xlswrite(M0,[(1:lambdaset)',L(:,:)],1,'A2');
xlswrite(M0,{'Number',H_two{1,:}},2,'A1');
xlswrite(M0,[(1:costset)',C(:,:)],2,'A2');
end