function policy = policymakerG(cust,M1_cap,thresh)
Leng = (cust+1)*(M1_cap);
policy = ones(1,Leng);
% customer Before last***************************************
for ss=1:cust-1
    for i=ss+1:cust+1:Leng
        if i<(cust+1)*thresh(ss)
            policy(1,i) = 2;
        else
            policy(1,i) = 3;
        end
    end
end
% customer Last *********************************************
for i=cust+1:(cust+1):Leng
        policy(1,i) = 2;
end
policy = [policy,[1,3*ones(1,cust)]];
policy = policy';
end