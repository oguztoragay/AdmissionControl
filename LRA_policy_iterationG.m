function [policy, iter, Value, warn] = LRA_policy_iterationG(P, R, policy0, max_iter)
% H can be added to the retrn values is necessary
lastwarn('');
if iscell(P); S = size(P{1},1); else S = size(P,1); end
if iscell(P); A = length(P); else A = size(P,3); end
if nargin > 2 && (size(policy0,1)~=S || any(mod(policy0,1)) || any(policy0<1)|| any(policy0>A) )
    disp('MDP Toolbox ERROR: policy0 must a (Sx1) vector with integer from 1 to A')
elseif nargin > 3 && max_iter <= 0
    disp('MDP Toolbox ERROR: The maximum number of iteration must be upper than 0')
else
    if nargin < 4; max_iter = 1000; end
    if nargin < 3
       policy0 = ones(S,1); %arbitrary
    end
    warns = false;
    iter = 0;
    policy = policy0;
    is_done = false;
    while ~is_done
        iter = iter + 1;
        [policy_next,value,warn] = LRA_eval_policy_matrixG(P,R,policy);
        if warn~=0; warns = true; end
        Value(1,iter)=double(value);
        if all(policy_next==policy) || iter == max_iter || warns
            is_done = true;
        else
            policy = policy_next;
        end
    end 
end
end

