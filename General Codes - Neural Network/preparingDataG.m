function preparingDataG(cust,costset,lambdaset,capmax,capinc)
Head1 = {'X','Acc','Rej','Opt','P4','P5','P6','P7','P8','P9'};
stat1 = zeros(capmax,9);
stat2 = zeros(costset,4);
stat3 = zeros(lambdaset,4);
both_stat = zeros(costset*lambdaset,capmax);
for k=1:capmax %capacities
    h = strcat(num2str(capinc*k),'Dat.xlsx');
    h2 = strcat(num2str(capinc*k),'Datmodi.xlsx');
    for i=1:costset %costs
        for j=1:lambdaset %lambdas
            m = lambdaset*(i-1)+j;
            L = xlsread(h,m);
            Ls = zeros(size(L,1),10);
            Ls(:,1) = (1:size(L,1))';
            Ls(:,2:10) = L(:,3)-L(:,1:9);
            xlswrite(h2,Head1,strcat(num2str(k),'-',num2str(i),'-',num2str(j)),'A1');
            xlswrite(h2,Ls,strcat(num2str(k),'-',num2str(i),'-',num2str(j)),'A2');
        end
    end
    h1 = strcat(num2str(capinc*k),'.xlsx');
    target1 = xlsread(h1,1);
    target1 = target1(:,4:12);
    target2 = xlsread(h1,6);
    target2 = target2(:,3:end);
    for k2=1:costset*lambdaset
        [~,minIndex] = min(target1(k2,:));
        stat1(k,minIndex) = stat1(k,minIndex)+1;
    end
    [~,I] = min(target1,[],2);
    both_stat(:,k) = I;
    for k3=1:2*(cust-1)
        min_1(k,k3) = min(target2(:,k3));
        max_1(k,k3) = max(target2(:,k3));
        average_1(k,k3) = mean(target2(:,k3));
        S_1(k,:)=std(target2);
        min_2(k,k3) = min(abs(target2(:,k3)));
        max_2(k,k3) = max(abs(target2(:,k3)));
        average_2(k,k3) = mean(abs(target2(:,k3)));
        S_2(k,:)=std(abs(target2));
    end
end
for i=1:costset
    t = both_stat(lambdaset*(i-1)+1:lambdaset*i,:);
    stat2(i,:) = [sum(t(:) == 4),sum(t(:) == 5),sum(t(:) == 7),sum(t(:) == 9)];
end
for j=1:lambdaset
    r = both_stat(j:lambdaset:costset*lambdaset,:);
    stat3(j,:) = [sum(r(:) == 4),sum(r(:) == 5),sum(r(:) == 7),sum(r(:) == 9)];
end
sz=[(cust-1)*capmax,2];
min_1=reshape(min_1,sz)';
max_1=reshape(max_1,sz)';
average_1=reshape(average_1,sz)';
S_1=reshape(S_1,sz)';
min_2=reshape(min_2,sz)';
max_2=reshape(max_2,sz)';
average_2=reshape(average_2,sz)';
S_2=reshape(S_2,sz)';
stat_page = strcat(num2str(cust),'-statistics.xlsx');
xlswrite(stat_page,stat1(:,:),'all-capacity','B2');
xlswrite(stat_page,stat2(:,:),'all-costs','B2');
xlswrite(stat_page,stat3(:,:),'all-lambdas','B2');
xlswrite(stat_page,[min_1(1,:);max_1(1,:);average_1(1,:);S_1(1,:)],'L-Bound Error','B2');
xlswrite(stat_page,[min_1(2,:);max_1(2,:);average_1(2,:);S_1(2,:)],'U-Bound Error','B2');
xlswrite(stat_page,[min_2(1,:);max_2(1,:);average_2(1,:);S_2(1,:)],'L-Bound AbsError','B2');
xlswrite(stat_page,[min_2(2,:);max_2(2,:);average_2(2,:);S_2(2,:)],'U-Bound AbsError','B2');
end