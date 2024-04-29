function neural(cust)
to_excel=[];
for cap=20:5:80
    for i=1:1000
        rand_mu = randi([10 30]);
        [lam,c] = randomlambdacost_Neural(cust);
        [~,lambda,T,~,Value,~,~,~,~] = one_finiteG(c,lam,rand_mu,cust,cap);
        to_excel = [to_excel;reshape(c',[1,cust*2]),lambda,T',Value(end)];
        disp([cap, i]);
    end
end
csvwrite('results.csv',to_excel)
end