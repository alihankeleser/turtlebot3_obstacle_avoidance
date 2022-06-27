%% Find the nearest obstacle
function [rmin] = nearestObstacle( laserScan )
%% define parameters
robotradius = 0.2; beta = 0.8;
%% find range of nearest obstacle
[rmin,idx] = min((laserScan.Ranges - robotradius)...
    .* (1 - beta * cos(readScanAngles(laserScan))));
% phimin = laserScan.angles(idx);
end