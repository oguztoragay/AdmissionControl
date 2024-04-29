function myreg(capmax,capinc)
innput=[];
output=[];
for i=1:capmax
    out = xlsread(strcat(num2str(i*capinc),'.xlsx'),1);
    inn1 = xlsread(strcat(num2str(i*capinc),'.xlsx'),7);
    inn2 = xlsread(strcat(num2str(i*capinc),'.xlsx'),8);
    output = [output;out];
    innput = [innput;inn1,inn2];
end
output=output(:,[7,8,9,10,11,12]);
innput=innput(:,[3,4,5,6,7,8,9,10,13,14,15,16]);
% for j=3:10
%     %[r,m,b] = regression(innput(:,3),output(:,10));
%     plotregression(innput(:,j),output(:,8),'Regression');
% end
% for j=3:7
%     [p,tbl,stats] = anova1(innput(:,j:j+3));
% end
% [p1,tbl1,stats1] = anovan(output(:,7),innput(3:10));
for j=1:6
    [b,se,pval,inmodel,stats,nextstep,history] = stepwisefit(innput,output(:,j));
end
end