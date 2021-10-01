function [A,B,C,D] = computeMatrices(J,lambda,gamma)

% v_j     = v(t_j,j)   for j >=1
% u_{j-1} = u(t_j,j-1) for j >=1
% Bv_0 + A[u0 u1 ...u_{j-1}]' = [v_1 v_2 ... v_j]'

c = zeros(J,1);
c(1) = 1;

B = eye(J,1);
for j = 2:J
    B(j,1) = lambda * B(j-1,1);
end

A = toeplitz(B,c);
B = lambda *B;

Q = (2/gamma)*ones(2,J);
Q(1,J) = 0;
Q(2,:) = -Q(2,:);

% Dv_0 + C[u0 u1 ...u_{j-1}]'+[t_1 -t_1]'  <= [T T]'

C = Q*A;
D = Q*B;