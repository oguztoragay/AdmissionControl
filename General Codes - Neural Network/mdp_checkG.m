function error_msg = mdp_checkG(P , R)
is_error_detected = false;
error_msg = '';

if iscell(P)
    s1 = size(P{1},1);
    s2 = size(P{1},2);
    a1 = length(P);
else
    [s1 s2 a1] = size(P);
end

if s1 < 1 || a1 < 1 || s1 ~= s2 
    error_msg = 'MDP Toolbox ERROR: The transition matrix must be on the form P(S,S,A) with S : number of states greater than 0 and A : number of action greater than 0';
    is_error_detected = true;
end

if ~is_error_detected
    a = 1;
    while a <= a1
        if iscell(P)
            error_msg = mdp_check_square_stochastic ( P{a} );
        else 
            error_msg = mdp_check_square_stochastic ( P(:,:,a) );
        end
        if isempty(error_msg)
	    a = a + 1;
        else
	    a = a1 + 1;
        end
    end
end

if ~is_error_detected
    if iscell(R)
        s3 = size(R{1},1);
        s4 = size(R{1},2);
        a2 = length(R);
    elseif issparse(R)
        s3 = size(R,1);
        s4 = s3;
        a2 = size(R,2);
    elseif ndims(R) == 3
        [s3 s4 a2] = size(R);
    else
        [s3 a2] = size(R);
        s4 = s3;
    end
    if s3 < 1 || a2 < 1 || s3 ~= s4
        error_msg = 'MDP Toolbox ERROR: The reward matrix R must be an array (S,S,A) or (SxA) with S : number of states greater than 0 and A : number of actions greater than 0';
        is_error_detected = true;
    end
end

if ~is_error_detected
     if s1~=s3 || a1 ~= a2
        error_msg = 'MDP Toolbox ERROR: Incompatibility between P and R dimensions';
	    is_error_detected = true;
     end
end