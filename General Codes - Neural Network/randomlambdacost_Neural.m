function [L,C] = randomlambdacost_Neural(cust)
L = randperm(50,cust);%Lambda
difs = -1*sort(randperm(30,cust));
c1 = -1*sort(randperm(50,cust));
C = [c1',difs'+c1']; %costs
end