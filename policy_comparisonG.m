function policy_comparisonG(kk,cust,costset,lambdaset,ktotal,c)
%% Reshaping c vector
for idx1=1:costset
    for idx2=1:cust
        costs{idx1}(idx2,1) = c(idx1,(2*idx2)-1);
        costs{idx1}(idx2,2)= c(idx1,2*idx2);
    end
end
%% Loops for Costs and Lambdas
% B=zeros(costset*lambdaset*20,4*(cust-1)+1);
e1 = zeros(costset*lambdaset,14); %14=[capacity,cost,lambda,error1(9columns),min among the policies and min index]
e2 = zeros(costset*lambdaset,14);
e3 = zeros(costset*lambdaset,14);
e4 = zeros(costset*lambdaset,14);
dat = 1;
for ii=1:costset % loop for all costs
    for jj=1:lambdaset % loop for all lambdas
        c = costs{ii};
        k = ktotal(jj,:);
        M1_cap = kk;
        [error1,error2,Error3,Error4] = policyestimationG(c,k,cust,M1_cap,costset,lambdaset,ii,jj);
        [mn1,minIndex1] = min(error1(1,:));
        [mn2,minIndex2] = min(error2(1,:));
        [mn3,minIndex3] = min(Error3(1,:));
        [mn4,minIndex4] = min(Error4(1,:));
        e1(dat,:) = [kk,ii,jj,error1,mn1,minIndex1];
        e2(dat,:) = [kk,ii,jj,error2,mn2,minIndex2];
        e3(dat,:) = [kk,ii,jj,Error3,mn3,minIndex3];
        e4(dat,:) = [kk,ii,jj,Error4,mn4,minIndex4];
        [B1,N1,WN1,SN1,MN1] = boundsG(c,k,cust,M1_cap);
        B(((ii-1)*lambdaset)+jj,:) = [ii,jj,B1]; %coming from boundsG.m function
        N(((ii-1)*lambdaset)+jj,:) = [ii,jj,N1]; %coming from boundsG.m function
        WN(((ii-1)*lambdaset)+jj,:) = [ii,jj,WN1]; %coming from boundsG.m function
        SN(((ii-1)*lambdaset)+jj,:) = [ii,jj,SN1]; %coming from boundsG.m function
        MN(((ii-1)*lambdaset)+jj,:) = [ii,jj,MN1]; %coming from boundsG.m function
        dat = dat+1;
        disp([kk,ii,jj]);
    end
end
header = {'Cap','Cost','Lambda','P1','P2','P3','P4','P5','P6','P7','P8','P9','Best','Index'};
xlswrite(strcat(num2str(kk),'.xlsx'),header,1,'A1');
xlswrite(strcat(num2str(kk),'.xlsx'),e1(:,:),1,'A2');
xlswrite(strcat(num2str(kk),'.xlsx'),header,2,'A1');
xlswrite(strcat(num2str(kk),'.xlsx'),e2(:,:),2,'A2');
xlswrite(strcat(num2str(kk),'.xlsx'),header,3,'A1');
xlswrite(strcat(num2str(kk),'.xlsx'),e3(:,:),3,'A2');
xlswrite(strcat(num2str(kk),'.xlsx'),header,4,'A1');
xlswrite(strcat(num2str(kk),'.xlsx'),e4(:,:),4,'A2');
xlswrite(strcat(num2str(kk),'.xlsx'),B(:,:),5,'A2');
xlswrite(strcat(num2str(kk),'.xlsx'),N(:,:),6,'A2');
xlswrite(strcat(num2str(kk),'.xlsx'),WN(:,:),7,'A2');
xlswrite(strcat(num2str(kk),'.xlsx'),SN(:,:),8,'A2');
xlswrite(strcat(num2str(kk),'.xlsx'),MN(:,:),9,'A2');
clear e1; clear e2; dat = 1;
end