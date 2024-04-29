function [argmax,value,warn] = LRA_eval_policy_matrixG(P, R, policy)
if iscell(P) 
    S = size(P{1},1); 
else
    S = size(P,1); 
end
if iscell(P) 
    A = length(P); 
else
    A = size(P,3); 
end
if size(policy,1)~=S || any(mod(policy,1)) || any(policy<1) || any(policy>A)
    disp('MDP Toolbox ERROR: policy must be a (1xS) vector with integer from 1 to A')
else
    for i=1:size(R,1)
        f(i,1)=R(i,policy(i,1));
    end
    for j=1:S
        Q(j,:)=P{policy(j,1)}(j,:);
    end
    for i=1:S
        for j=1:S
            if j==1 
                A(i,j)=1; 
            elseif i==j && j~=1 
                A(i,j)=1-Q(i,j);
            else
                A(i,j)=-1*Q(i,j); 
            end
        end
    end
%% Solving the system of equation and gather information about warnings
    % h = bicgstab(A,f,[],50);
    h=A\f;
    warn=0;
    if ~isempty(lastwarn)
        warn=warn+1;
    end
%% Generating the new policy and calculating the corresponding cost
    value=h(1,1);
    h(1,1)=0;
        for i=1:S
            a=R(i,1)+P{1}(i,:)*h;
            b=R(i,2)+P{2}(i,:)*h;
            c=R(i,3)+P{3}(i,:)*h;
            [argvalue(i), argmax(i)] = max([a,b,c]);
        end
%Note:If the maximum value occurs more than once, then max returns the index corresponding to the first occurrence.
end
argmax=argmax';
end