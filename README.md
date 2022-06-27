# turtlebot3_obstacle_avoidance

In this repo you can find the implementation of Vector Field Histogram methods for obstacle avoidance of turtlebot3.

1- You need to run gazebo and RViz simulations:

```
roslaunch turtlebot3_gazebo turtlebot3_world.launch 
```
```
roslaunch turtlebot3_navigation turtlebot3_amcl.launch 
```

Note: You should place "turtlebot3_amcl.launch" file into the "~/catkin_ws/src/turtlebot3/turtlebot3_navigation/launch" folder

2- You can run "ObstacleAvoidance.m" (one of the obstacle avoidance method from related folder either "vfh" or "vfh+")
