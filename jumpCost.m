function LD = jumpCost(v,gamma,lambda,hdes)

    LD = gamma*hdes*(v+sqrt(2*gamma*hdes))^2/2;
    
    if v <= -sqrt(2*gamma*hdes)/lambda
        LD = min(LD,(v^2/2-gamma*hdes)^2-(lambda^2*v^2/2-gamma*hdes)^2);
    end
    
end