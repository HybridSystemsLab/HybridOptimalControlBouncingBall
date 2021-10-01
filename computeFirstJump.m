function [t1,v0] = computeFirstJump(xi, gamma)

h = xi(1);
v = xi(2);

t1 = (v + sqrt(v^2 + 2*gamma*h)) / gamma;   % time of first impact/jump
v0 = sqrt(v^2 + 2*gamma*h);                 % absolute value of velocity at first impact

end