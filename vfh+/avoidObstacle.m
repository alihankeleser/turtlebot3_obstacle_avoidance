%% Calculate the linear and angular velocities
function [ v, omega] = avoidObstacle( laserscan )
%% define parameters
komega = 2.0; % gain for turn rate
omegamin = -1.5;
omegamax = 1.5;
vsafe = 0.5;
%goalRadius = 0.5;
rsafe = 0.5;
rstop = 0.1;
%% calculate the linear velocity
if laserscan.rmin < rstop
    v = 0;
elseif rstop <= laserscan.rmin && laserscan.rmin <= rsafe
    v = vsafe * ((laserscan.rmin - rstop)/(rsafe - rstop));
elseif rsafe < laserscan.rmin
    v = vsafe;
end
%% calculate the angular velocity
omega = komega * laserscan.steeringDirection;
%% saturate the angular velocity
if omega < omegamin
    omega = omegamin;
elseif omega > omegamax
    omega = omegamax;
end
end