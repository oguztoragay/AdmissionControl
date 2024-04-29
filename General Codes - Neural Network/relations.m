function relations(cust,cost,lambda)
X=xlsread('10.xlsx',8,'A2:D101');
% x1=X(:,3);
x1=(1:100)';
x2=(1:100)';
% x2=X(:,4);
Y=xlsread('10.xlsx',1,'A2:L101');
y=Y(:,8);
z=(1:100)';
% plot(z,x1,z,x2,z,y);
%  scatter(x2,x1);
 surf(x1,x2,y);
% plot(z,y);
end