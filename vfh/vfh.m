function steeringdirection = vfh(ranges, angles, targetdir)
%% Define internal parameters
numsectors = 64; rmax = 2.5; alpha = 1.5; narrow = 0.17;
%% For histogram calculation proceed
ranges = max(0,ranges); % the range datas smaller than 0 become 0
minangle = min(angles); % find minimum angle
maxangle = max(angles); % find maximum angle
sectorincrement = (maxangle-minangle)/numsectors; % determine the sectorincrement
sectormidpoints = linspace(minangle, maxangle, numsectors); % determine the mid point of sectors
sector_edges = [sectormidpoints - sectorincrement/2, ...
sectormidpoints(end) + sectorincrement/2]; % determine the sectoredges
% filter the range data by selecting only the range data with ri < rmax using find
valididx = find(ranges<rmax); 
validranges = ranges(valididx);
validangles = angles(valididx);
% compute the vector of weightedranges from the validranges, rmax and alpha
weightedRanges = (1.0- validranges/rmax).^alpha;
% determine the association of angles to the sectors (sector_edges) with the function histcounts
[~,edges,bin] = histcounts(validangles, sector_edges);
% accumulate the vector of weightedranges in the polar density histogram
% obstacledensity of length numsectors according to first equation(in assignment)
% based on the array of bin indices bin
obstacleDensity = zeros(1, numsectors);
for i=1:length(bin)
obstacleDensity(1, bin(i)) = ...
obstacleDensity(1, bin(i)) + weightedRanges(i);
end
% Smooth the polar obstacle density histogram obstacledensity with
% the Matlab function filtfilt according to equation (2) (in assignment) 
% with a filter window size l = 3 and filter width of 2l + 1 = 7
% b = (1/7) * [1,2,3,4,3,2,1]; a = 1;
% obstacleDensitySmooth = filtfilt(b,a,obstacleDensity);
%% Plot the polar obstacle density in a polarplot
subplot(2,2,1);
polarplot(angles,ranges,'r*','MarkerSize',1)
title('Polarplot range readings')
subplot(2,2,2);
polarplot(sectormidpoints,obstacleDensity)
hold on 
title('Polarplot obstacle density histogram')
%figure(2)
%polarplot(sectormidpoints,obstacleDensitySmooth)
%[~,hmaxidx] = min(validranges);
%hmax = obstacleDensity(bin(hmaxidx));
%% Determine hmax
% calculate it by setting ri to a minimal radius and calculate h as shown in equation 1
rmin = min(validranges);
hmax = (1.0- rmin/rmax).^alpha;
polarplot(angles,hmax*ones(size(angles)))
hold off
% Determine the logical array of occupied sectors occupiedsectors (non candidate
% valleys) with a polar density above the threshold h > hmax according to equation (3)
sectoroccupied = zeros(1,numsectors); % boolean
sectoroccupied(obstacleDensity > hmax) = true;
%% Plot the occupied sectors for the sample range data ranges and angles in a separate subfigure with polarplot
subplot(2,2,3);
polarplot(sectormidpoints,sectoroccupied)
title('Polarplot binar occupancy histogram')
%% Determine the upper and lower indices of the nonoccupied sectors ~occupiedsector
changes = diff([0 ~sectoroccupied 0]);
foundSectors = find(changes);
sectors = reshape(foundSectors, 2, []);
sectors(2,1:end) = sectors(2,1:end) - ones(1, size(sectors, 2));
% sectors(1,:) contains the lower indices and sectors(2,:) the upper indices of
% free sectors
% [~,targetdirsector] = min(abs(sectormidpoints - targetdir));
%% Determine target direction according to case 1:
i = 1;
% Check whether the target direction targetdir is within the boundaries of any of the
% non occupied sectors
while i <= length(sectors) % for each nonoccupiedsector
    if targetdir >= sectormidpoints(sectors(1,i)) && targetdir <= sectormidpoints(sectors(2,i))
        %case1 = 1;
        steeringdirection = targetdir; % return targetdir as steeringdirection
        subplot(2,2,4); % Plot the steeringdirection
        polarplot([0 targetdir],[0 1],'b')
        return % exit the function
    end
    i = i + 1;
end
%% Determine target direction according to case 2-3:
i = 1;
b = 1;
candidatedir = zeros(1,2*length(sectors)); % define candidate direction vector
candidatenorm = zeros(1,2*length(sectors)); % define candidate norm vector
while i <= length(sectors)
    % check if the sector is narrow
    if (sectormidpoints(sectors(2,i)) - sectormidpoints(sectors(1,i))) > narrow % nonnarrow sectors
        % each nonnarrow sector has 2 candidate directions
        candidatedir(b) = sectormidpoints(sectors(1,i)) + narrow/2; % first candidate direction
        candidatenorm(b) = 1;
        b = b + 1;
        % add a null between each candidate to make them look understandable
        candidatedir(b) = 0;
        candidatenorm(b) = 0;
        b = b + 1;
        candidatedir(b) = sectormidpoints(sectors(2,i)) - narrow/2; % second candidate direction
        candidatenorm(b) = 1;
        b = b + 1;
        candidatedir(b) = 0;
        candidatenorm(b) = 0;
        b = b + 1;
    else % narrow sectors
        % each narrow sector has 1 candidate direction
        candidatedir(b) = (sectormidpoints(sectors(1,i)) + sectormidpoints(sectors(2,i))) /2;
        candidatenorm(b) = 1;
        b = b + 1;
        candidatedir(b) = 0;
        candidatenorm(b) = 0;
        b = b + 1;
    end
    i = i + 1;
end
if sum(candidatedir) ~= 0 % check the cadidate direction to calculate steeringdirection
    % it is not work if the sum of cadidatedir is 0
    [~,canidx] = min(abs(candidatedir(1:2:end) - targetdir)); % calculate the closest direction to target direction
    % use 2*canidx because 0 was added between each direction
    steeringdirection = candidatedir(2*canidx - 1); 
    subplot(2,2,4); % plot candidate direcitons
    polarplot(candidatedir,candidatenorm)
    hold on
    polarplot([0 steeringdirection],[0 1],'r') % plot steeringdirection
    polarplot([0 targetdir],[0 1],'b') % plot target direction
    hold off
    title('target, candidate and steering direction')
    return % exit the function
end
%% Case 4
% If the set of candidate directions is empty, the vfh function returns the output
% parameter steeringdirection = NaN
subplot(2,2,4); % plot target direction
polarplot([0 targetdir],[0 1],'b')
steeringdirection = NaN;
title('target direction')
end