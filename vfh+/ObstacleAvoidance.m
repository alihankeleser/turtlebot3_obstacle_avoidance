%% Settings
clear all;close all;clc; % clear all variables in workspace, close all things (for example plot) and clean the command window 
tftree = rostf; % define a variable with the ROS transformation tree
[velPub, velMsg] = rospublisher('/cmd_vel'); % Define a publisher velPub for publishing velocity commands on the topic /cmd_vel
navGoalSub = rossubscriber('/move_base_simple/goal'); % subscriber for the topic ’/move_base_simple/goal’
disp('select navgoal in RVIZ to start obstacle avoidance');
navGoalMsg = receive(navGoalSub); % wait here until get a goal
pose = PoseHandle; % define a variable in PoseHandle class
laserscan = ScanHandle; % define a variable in ScanHandle class
scanSubCallback = rossubscriber('/scan',{@scanCallback,velPub,navGoalSub,tftree,pose,laserscan}); % define a callback subscriber
% Matlab will wait for the receive of a goal message
%[targetDirection, rho] = cart2pol(pose.x, pose.y);
%% Define parameters
rho = inf; % define rho at the beginning inf
goalRadius = 0.5;
controlRate = 10;
rateObj = robotics.Rate(controlRate);
maxTime = 20;
pause(1) % wait 1 sec (without this get error)
%% While loop
% run the loop till maxtime or reaching the goal
while (rateObj.TotalElapsedTime < maxTime) && (goalRadius < rho)
    [~,rho] = cart2pol(pose.x, pose.y); % get new rho
    [ v, omega] = avoidObstacle( laserscan ); % get new velocities from velocity function
    % set the velocities on the velMsg and send
    velMsg.Linear.X = v;
    velMsg.Angular.Z = omega;
    send(velPub,velMsg);
    
    waitfor(rateObj)
end
%% Stop the robot
% at the end of the motion stop the robot
velMsg.Linear.X = 0;
velMsg.Angular.Z = 0;
send(velPub, velMsg);

clear scanSubCallback;