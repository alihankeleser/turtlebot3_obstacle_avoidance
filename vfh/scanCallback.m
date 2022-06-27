%% Find the new steering direction w.r.t. the new robot position
function [] = scanCallback( ~, scanMsg, velPub, navGoalSub, tftree, pose, laserscan)
% velMsg = rosmessage(velPub);
navGoalMsgRobot = transform(tftree,'base_link', navGoalSub.LatestMessage); % goal w.r.t. baselink
[pose.x, pose.y, pose.theta] = PoseStampedMsg2Pose(navGoalMsgRobot); % find the new goal pose
[targetDirection, ~] = cart2pol(pose.x, pose.y); % calculate the renewed target direction
% find the new value of steering direction
laserscan.steeringDirection = vfh(scanMsg.Ranges,readScanAngles(scanMsg),targetDirection);
laserscan.rmin = nearestObstacle( scanMsg ); % find range of nearest obstacle

% [ v, omega] = avoidObstacle( laserscan );
% velMsg.Linear.X = v;
% velMsg.Angular.Z = omega;

end