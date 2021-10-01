function [optimalInput,optimalCost] = solveOCP(xi,u0,umin,umax,gamma,lambda,hdes,T)

objective = @(u)costFunctional(xi,u,gamma,lambda,hdes);

J = length(u0);
[t1,v0] = computeFirstJump(xi,gamma);

[~,~,A,B] = computeMatrices(J,lambda,gamma);

b = -B*v0 +[T-t1; t1- T];

[optimalInput,optimalCost] = ...
    fmincon(objective,u0,A,b,[],[],umin*ones(length(u0),1),umax*ones(length(u0),1));

end