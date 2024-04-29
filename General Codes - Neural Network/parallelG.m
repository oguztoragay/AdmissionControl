function parallelG(cust,costset,lambdaset,capmax,capinc)
tic
[ktotal,c]=randomlambdacostG(cust,costset,lambdaset);
parfor i = 1:capmax
    policy_comparisonG(capinc*i,cust,costset,lambdaset,ktotal,c);
end
preparingDataG(cust,costset,lambdaset,capmax,capinc);
toc
display(toc);
end