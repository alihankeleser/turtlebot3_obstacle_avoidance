%% Find the new steering direction w.r.t. the new robot position
function [] = scanCallback( ~, scanMsg, velPub, navGoalSub, tftree, pose, laserscan)
navGoalMsgRobot = transform(tftree,'base_link', navGoalSub.LatestMessage); % goal w.r.t. baselink
[pose.x, pose.y, pose.theta] = PoseStampedMsg2Pose(navGoalMsgRobot); % find the new goal pose
[targetDirection, ~] = cart2pol(pose.x, pose.y); % calculate the renewed target direction
% settings of vfhplus
vfhplus = controllerVFH;
vfhplus.DistanceLimits = [0.05 1];
vfhplus.RobotRadius = 0.2;
vfhplus.MinTurningRadius = 0.2;
vfhplus.SafetyDistance = 0.1;
vfhplus.UseLidarScan = true;
scan = lidarScan(scanMsg);
% find the new value of steering direction
laserscan.steeringDirection = vfhplus(scan, targetDirection);
laserscan.rmin = nearestObstacle( scanMsg ); % find range of nearest obstacle
end