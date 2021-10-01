function cost = costFunctional(xi,u,gamma,lambda,hdes)

J = length(u);

% t1 is time of first jump
% v0 is abs. value of velocity at first impact
[t1,v0] = computeFirstJump(xi,gamma);
[A,B,~,~] = computeMatrices(J,lambda,gamma);

% calculate vector of post jump velocities v
v = A*u+B*v0;

cost = jumpCost(-v0,gamma,lambda,hdes);

% velocity right before jump j is negative of velocity right after jump j-1
for j = 1:J-1
    cost = cost+jumpCost(-v(j),gamma,lambda,hdes);
end

% energy conserved during flows, can compute 
% terminal cost using velocity right after last jump
cost = cost+terminalCost(-v(J),gamma,hdes);

end


