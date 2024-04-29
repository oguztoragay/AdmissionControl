function [error1,error2,Error3,Error4]=policyestimationG(c,k,cust,M1_cap,costset,lambdaset,ii,jj)
dif = -1*(c(:,2)-c(:,1));
Dat = [];
% ------------------- Estimating the bounds --------------------
sigma = sum(k(:).*dif(:));
mu_lest = zeros(cust,1);
mu_uest = zeros(cust,1);
mu_lest(cust-1) = ((k(1,cust)*(dif(cust,1)-dif(cust-1,1)))+1)/dif(cust,1);
mu_uest(cust-1) = sigma/dif(cust-1,1);
for i=cust-2:-1:1
    mu_lest(i) = (((k(1,i+1)*(dif(i+1,1)-dif(i,1)))+1)/dif(i+1,1))+(mu_lest(i+1)*((dif(cust,1)-dif(i,1))/(dif(cust,1)-dif(i+1,1))));
    mu_uest(i) = sigma/dif(i,1);
end
%------------------------------Added Later---------------------------------
 [B,~,~,~]=boundsG(c,k,cust,M1_cap);
 mu_l = B(:,1:cust-1); 
 mu_u = B(:,2*(cust-1)+1:2*(cust-1)+cust-1);
 mu_lest = [mu_l';0];
 mu_uest = [mu_u';0];
%--------------------------------------------------------------------------
% ------------------- Start to solve ------------------------ 
H = mu_uest(1)+10;
dat = 1;
for mu=0.01:H
    [~,~,~,~,value,iter,warn,P,R] = one_finiteG(c,k,mu,cust,M1_cap);% Optimal Policy
    %------------------Policy l--------------------------------
    policy1 = [repmat([1;2*ones(cust,1)],M1_cap,1);[1;3*ones(cust,1)]];% Accept All
    %------------------Policy 2--------------------------------
    policy2 = [repmat([1;3*ones(cust-1,1);2],M1_cap,1);[1;3*ones(cust,1)]];% Reject All
    %------------------Policy 4--------------------------------
    if mod(M1_cap,2)==0
        thresh4 = M1_cap/2;
    else
        thresh4 = ceil(M1_cap/2);
    end
    for icust=1:cust-1
        if mu<=mu_lest(icust)
              thresh(icust) = 0;
        elseif mu_lest(icust)<mu && mu<=mu_uest(icust)
              thresh(icust) = thresh4(1);
        else
              thresh(icust) = M1_cap;
        end
    end
    policy4 = policymakerG(cust,M1_cap,thresh);
    %-------------------Policy 5-------------------------------
    for icust=1:cust-1
        T5(icust) = (mu_uest(icust)-mu_lest(icust))/M1_cap;
    end   
    for icust=1:cust-1
        D5(icust) = (mu-mu_lest(icust))/T5(icust);
    end
    for icust=1:cust-1
        thresh(icust) = ceil(D5(icust));
    end
    for icust=1:cust-1
        if thresh(icust)<0
        thresh(icust) = 0;
        elseif thresh(icust)>M1_cap
            thresh(icust) = M1_cap;
        end
    end
    policy5 = policymakerG(cust,M1_cap,thresh);
    %-------------------Policy 6-------------------------------
    for icust=1:cust-1
        D6(icust) = mu*(1-exp(mu_lest(icust)-mu));
    end
   for icust=1:cust-1
       thresh(icust) = ceil(D6(icust));
   end
    for icust=1:cust-1
        if thresh(icust)<0
        thresh(icust) = 0;
        elseif thresh(icust)>M1_cap
            thresh(icust) = M1_cap;
        end
    end
    policy6 = policymakerG(cust,M1_cap,thresh);
    %-------------------Policy 7-------------------------------
    for icust=1:cust-1
        D7(icust) = mu*((mu-mu_lest(icust))/(mu_uest(icust)-mu_lest(icust)));
    end
    for icust=1:cust-1
        thresh(icust) = ceil(D7(icust));
    end 
    for icust=1:cust-1
        if thresh(icust)<0
        thresh(icust) = 0;
        elseif thresh(icust)>M1_cap
            thresh(icust) = M1_cap;
        end
    end
    policy7 = policymakerG(cust,M1_cap,thresh);
    %-------------------Policy 9-------------------------------
    for icust=1:cust-1
        T9(icust) = (mu_uest(icust)-mu_lest(icust))/4;
    end
    D9 = M1_cap/4;
    kD9 = ceil(D9)-1;
    for icust=1:cust-1
        if mu<mu_lest(icust)
            thresh(icust) = 0;
        elseif mu>=mu_lest(icust) && mu<mu_lest(icust)+T9(icust)
            thresh(icust) = kD9;
        elseif mu>=mu_lest(icust)+T9(icust) && mu<mu_lest(icust)+2*T9(icust)
            thresh(icust) = 2*kD9;
        elseif mu>=mu_lest(icust)+2*T9(icust) && mu<mu_lest(icust)+3*T9(icust)
            thresh(icust) = 3*kD9;
        else
            thresh(icust) = M1_cap;
        end
    end
    policy9 = policymakerG(cust,M1_cap,thresh);
    %=====================================================
    [~,value1,~] = LRA_eval_policy_matrixG(P, R, policy1);
    [~,value2,~] = LRA_eval_policy_matrixG(P, R, policy2);
    [~,value4,~] = LRA_eval_policy_matrixG(P, R, policy4);
    [~,value5,~] = LRA_eval_policy_matrixG(P, R, policy5);
    [~,value6,~] = LRA_eval_policy_matrixG(P, R, policy6);
    [~,value7,~] = LRA_eval_policy_matrixG(P, R, policy7);
    [~,value9,~] = LRA_eval_policy_matrixG(P, R, policy9);
    %----------------Policy 8-----------------------------
    if value1<=value2
        value8 = value2;
    else
        value8 = value1;
    end
    Dat(dat,1) = value1; 
    Dat(dat,2) = value2; 
    Dat(dat,3) = value(1,end);
    if isnan(value(1,end))
        Dat(dat,3) = value(1,end-1);
    end
    Dat(dat,4) = value4; 
    Dat(dat,5) = value5; 
    Dat(dat,6) = value6;
    Dat(dat,7) = value7; 
    Dat(dat,8) = value8; 
    Dat(dat,9) = value9;
    Dat(dat,10) = iter;
    Dat(dat,11) = warn;
    for j=1:9
        error3(dat,j) = (Dat(dat,j)-Dat(dat,3))/Dat(dat,3);
        error4(dat,j) = Dat(dat,3)-Dat(dat,j);
    end
    dat = dat+1;
end
sayfa = ['Sheet',num2str(((ii-1)*lambdaset+jj))];
xlswrite([num2str(M1_cap),'Dat.xlsx'],Dat(:,:),sayfa,'A1');
for j=1:9
    absolute = abs(Dat(:,3)-Dat(:,j));
    error1(1,j) = sum(absolute)/(costset*lambdaset);
    error2(1,j) = (-1*sum(absolute)/sum(Dat(:,3)))/(costset*lambdaset);
    Error3(1,j) = sum(error3(:,j));
    Error4(1,j) = sum(error4(:,j))/H;
end
error1(:,3)=100000;
error2(:,3)=100000;
Error3(:,3)=100000;
Error4(:,3)=100000;
end