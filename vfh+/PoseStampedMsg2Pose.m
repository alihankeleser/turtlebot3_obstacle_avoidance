function [ x, y, theta ] = PoseStamped2Pose( poseMsg )
% convert odometry message to vector
x=poseMsg.Pose.Position.X;
y=poseMsg.Pose.Position.Y;
eul=quat2eul([poseMsg.Pose.Orientation.W poseMsg.Pose.Orientation.X  poseMsg.Pose.Orientation.Y poseMsg.Pose.Orientation.Z]);
theta=eul(1);
end

