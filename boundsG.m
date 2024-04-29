function [B,N,WN,SN,MN] = boundsG(c,k,cust,M1_cap)
stop = 0; catched = zeros(2,cust-1);
mu_l = zeros(1,cust-1); mu_u = zeros(1,cust-1);
mu_lest = zeros(1,cust-1); mu_uest = zeros(1,cust-1); mu = 0;
dif = -1*(c(:,2)-c(:,1)); sigma = sum(k(:).*dif(:));
for i=cust-1:-1:1
    mu_lest(i) = estimator1(i);
    mu_uest(i) = estimator2(i);
end
while ~stop
    mu = mu+1;
    [~,~,T,~,~,~,~,~,~] = one_finiteG(c,k,mu,cust,M1_cap);
    T=T';
    for icust=1:cust-1
        if catched(2,1)
            stop = 1;
        end
        if T(icust)>0 && catched(1,icust)==0 && ~stop && T(cust)==M1_cap
        mu_l(icust) = mu;
        catched(1,icust) = 1;
        end
        if T(icust)>M1_cap-1 && catched(2,icust)==0 && ~stop && T(cust)==M1_cap
            mu_u(icust) = mu;
            catched(2,icust) = 1;
        end
    end
end
B = [mu_l,mu_lest,mu_u,mu_uest,M1_cap];
N = [(mu_l-mu_lest)./mu_lest,(mu_u-mu_uest)./mu_uest];
WN = [abs(mu_l-mu_lest)./mu_lest,abs(mu_u-mu_uest)./mu_uest];
SN = (mu_u-mu_l)./(mu_uest-mu_lest);
MN = (mu_uest-mu_lest)-(mu_u-mu_l);
function mu_ll = estimator1(i)
    if i==cust-1
        mu_ll = ((k(i+1)*(dif(i+1,1)-dif(i,1)))+1)/dif(i+1,1);
    else
        mu_ll = (((k(i+1)*(dif(i+1,1)-dif(i,1)))+1)/dif(i+1,1)) + (mu_lest(i+1)*(dif(cust,1)-dif(i,1))/(dif(cust,1)-dif(i+1,1)));
    end
end
function mu_uu = estimator2(i)
    mu_uu = (sigma/dif(i,1));
end
end