function [c,lambda,T,policy,Value,iter,warn,P,R]=one_finiteG(c,k,mu,cust,M1_cap)
%% Generating Input Data
mu_f = mu; % mu of finite method
mu_inf = 10; % mu of infinite method
M = 1; %Number of finite method
lambda = [mu_f,k];
L = sum(lambda);
Lambda = lambda/L;
%% Transition--Creating P matrices
sizm = cust+1;
sizM = (M1_cap+1)*(cust+1);
P = cell(1,M+2); % Array of all transition matrixes depends on the actions
for i=1:M+2
    P{i} = zeros(sizM,sizM); % Creating the probability matrices for all actions and make them equal to zero
end
for k = 1:M+2
    switch k
        case 1 % p for Doing Nothing***************************************
            d1 = zeros(sizm,M1_cap*sizm);
            d2 = zeros(sizm,(M1_cap-1)*sizm);
            A1 = zeros(sizm,sizm);
            for i=1:sizm
                A1(i,:) = Lambda;
            end
            A2 = zeros(sizm,sizm);
            A2(:,1) = mu_f/L;
            A3 = zeros(sizm,sizm);
            A3(1,2:end) = Lambda(1,2:end);
            A3(2:end,2:end) = eye(cust,cust).*(1-(mu_f/L));
            P11 = [A2,A3,d2];
            Pdn = [A1,d1;P11];
            for i=1:M1_cap-1
                P11 = circshift(P11,sizm,2);
                Pdn = [Pdn;P11];
            end
            P{1} = Pdn;
        case 2 % p for Assigning to method 1*******************************
            A1 = zeros(sizm,sizm);
            A1(1,:) = Lambda;
            A1(2:end,1) = mu_f/L;
            A2 = zeros(sizm,sizm);
            A2(2:end,1) = mu_f/L;
            A3 = zeros(sizm,sizm);
            A4 = zeros(sizm,sizm);
            A3(1,:) = Lambda;
            for i=2:cust+1
                A3(i,2:end) = Lambda(1,2:end);
                A4(i,2:end) = Lambda(1,2:end);
            end
            P22 = [d2,A2,A3];
            PA1 = [P22;P22];
            for i=1:M1_cap-2
                P22 = circshift(P22,-1*(sizm),2);
                PA1 = [P22;PA1];
            end
            PA1 = [A1,A4,d2;PA1];
            P{2} = PA1;
        case 3 % p for Assigning to method 2*******************************
            A1 = zeros(sizm,sizm);
            for i=1:sizm
                A1(i,:) = Lambda;
            end
            A2 = zeros(sizm,sizm);
            A2(1,:) = Lambda;
            A2(2:end,1) = mu_f/L;
            A3 = A1-A2;
            P31 = [A2,A3,d2];
            PA2 = [A1,d1;P31];
            for i=1:M1_cap-1
                P31 = circshift(P31,sizm,2);
                PA2 = [PA2;P31];
            end
            P{3} = PA2; 
    end
end
%% Costs--Creating R matrix
bigM = -1000;
BigM = bigM*ones(cust,1);
cost = [0 bigM bigM ; BigM c(:,1) c(:,2)];
R = [0 bigM bigM ; BigM BigM c(:,2)];    
for i=1:M1_cap
    R = [cost;R];
end
%% Solving the MDP
mdp_checkG(P,R);
[policy, iter, Value, warn] = LRA_policy_iterationG(P, R);
%% Modifying the solution
q = reshape(policy,[cust+1,size(policy,1)/(cust+1)]);
%% Calculating the threshold from solution
T = zeros(cust,1);
for i=2:cust+1
    for j=2:M1_cap+1
        if q(i,j)>q(i,j-1)
            T(i-1,1) = j-1;
        end
    end
end
end