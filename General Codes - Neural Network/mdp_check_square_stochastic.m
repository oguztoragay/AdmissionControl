function error_msg = mdp_check_square_stochastic( Z )
error_msg = '';
[s1 s2] = size(Z);
if s1 ~=s2
   error_msg = 'MDP Toolbox ERROR: Matrix must be square';
elseif max(abs(sum(Z,2)-ones(s2,1))) > 10^(-12)
   error_msg = 'MDP Toolbox ERROR: Row sums of the matrix must be 1';
elseif ~isempty(find (Z < 0))
   error_msg = 'MDP Toolbox ERROR: Probabilities must be non-negative';
end

