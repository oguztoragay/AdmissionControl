function comparingtwo
for i=10:10:50
    for j=1:4
        target1=xlsread(strcat(num2str(i),'.xlsx'),j);
        target2=xlsread(strcat(num2str(i),'s.xlsx'),j);
        p{j}(i/10,:)=sum(target1(:,4:12));
        q{j}(i/10,:)=sum(target2(:,4:12));
    end
end
end