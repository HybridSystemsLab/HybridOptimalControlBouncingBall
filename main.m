clear all
close all
clc

addpath('./Example_1.3-Bouncing_Ball_with_Input/');

% Parameters specified below for easy access, but initialize the Simulink model
% from file just in case 
initialization_ex1_3;   % Example_1.3-Bouncing_Ball_with_Input\initialization_ex1_3.m to

%% Parameters

gamma = 9.81;   % gravity constant          - (0<gamma )
lambda = 0.8;   % restitution coefficent    - (0<=lambda<1)

umin = 1.0;     % lower bound on input
umax = 10.0;    % upper bound on input

hdes = 2.0;     % desired height

%%
T = 4.00;
J = 2;          % number of jumps; assuming >= 1
u0 = umin*ones(J,1);

xi = [1; 0];                           
initialCondition = xi;
stopTime = T ;

%%
[uStar,~] = solveOCP(xi,u0,umin,umax,gamma,lambda,hdes,T);

delta = -0.1:0.01:0.1;

optimalInputs = zeros(length(delta),length(delta),J);
optimalInputNormDiffs = zeros(length(delta));
optimalCosts = zeros(length(delta));
for i = 1:length(delta)
    for k = 1:length(delta)
        [optimalInput,optimalCost] = ...
            solveOCP(xi+[delta(i); 0],u0,umin,umax,gamma,lambda,hdes,T+delta(k));
        optimalInputs(i,k,:) = optimalInput;
        optimalCosts(i,k) = optimalCost;
        optimalInputNormDiffs(i,k) = norm(optimalInput - uStar);
    end
end
%%
FS = 8;                     %fontsize

figure(1), meshc(xi(1)+delta,T+delta,optimalCosts), h = gcf;
xlabel(''), ylabel('')
xlabel('$p$ [m]','FontName','Times','FontSize',FS,'Interpreter','latex')
ylabel('$T$ [s]','FontName','Times','FontSize',FS,'Interpreter','latex')
zlabel('$h$','FontName','Times','FontSize',FS,'Interpreter','latex')
set(gca,'FontName','Times','FontSize',FS)
set(h,'Units','inches','Position',[2 2 3.4 2])
yticks([3.9:0.05:4.1])

figure(2), meshc(xi(1)+delta,T+delta,optimalInputNormDiffs), h = gcf;
xlabel(''), ylabel('')
xlabel('$p$ [m]','FontName','Times','FontSize',FS,'Interpreter','latex')
ylabel('$T$ [s]','FontName','Times','FontSize',FS,'Interpreter','latex')
zlabel('$|\mathbf{u}-\mathbf{u}^*|$ [m/s]','FontName','Times','FontSize',FS,'Interpreter','latex')
set(gca,'FontName','Times','FontSize',FS)
set(h,'Units','inches','Position',[2 2 3.4 2])
yticks([3.9:0.05:4.1])

%%
% rule for jumps                                                        
rule = 1;   % prioritize jumps                                                                                                       
                                                                        
% solver tolerances
RelTol = 1e-8;
MaxStep = .005;

% tolerance parameter for prediction.m
eps = MaxStep;

T = 2.00;
J = 1;          % number of jumps; assuming >= 1
u0 = umin*ones(J,1);

xi = [2; 0];                                                            

figure(3), clf
delta = -1.2:0.4:0.0;
for i = 1:length(delta)
    initialCondition = xi+[delta(i); 0]
    stopTime = T+delta(i)/2;
    [optimalInput,~] = ...
        solveOCP(initialCondition,u0,umin,umax,gamma,lambda,hdes,stopTime);
    optimalInput = [optimalInput; 0.0];
    sim('Example1_3.slx')
    plotHybridArc(t,j,x(:,1))
    grid on, hold on
end
%%
h = gcf;
xlabel(''), ylabel('')
xlabel('$j$','FontName','Times','FontSize',FS,'Interpreter','latex')
ylabel('$t$ [s]','FontName','Times','FontSize',FS,'Interpreter','latex')
zlabel('$p$ [m]','FontName','Times','FontSize',FS,'Interpreter','latex')
set(gca,'FontName','Times','FontSize',FS)
set(h,'Units','inches','Position',[2 2 3.4 2])
xticks([0 1])
yticks([0:0.4:2])
zticks([0:0.5:2.5])
axis([0 1 0 2 0 2.5])
