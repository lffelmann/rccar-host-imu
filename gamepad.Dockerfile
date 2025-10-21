ARG ROS_DISTRO=jazzy
FROM ros:${ROS_DISTRO}

RUN apt-get update && apt-get install -y \
     git \
     python3-colcon-common-extensions \
  && rm -rf /var/lib/apt/lists/*

ENV WORKSPACE=/opt/ros2_ws
RUN mkdir -p ${WORKSPACE}/src
WORKDIR ${WORKSPACE}/src

RUN git clone https://github.com/tuw-robotics/tuw_robotics.git \
 && git clone https://github.com/tuw-robotics/tuw_msgs.git \
 && git clone -b ${ROS_DISTRO} https://github.com/ros-geographic-info/geographic_info.git

RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-geometry-msgs \
    ros-${ROS_DISTRO}-nav-msgs \
    ros-${ROS_DISTRO}-std-msgs \
    ros-${ROS_DISTRO}-angles \
    ros-${ROS_DISTRO}-tf2 \
    ros-${ROS_DISTRO}-tf2-ros \
    ros-${ROS_DISTRO}-tf2-geometry-msgs \
    ros-${ROS_DISTRO}-joint-state-publisher \
    ros-${ROS_DISTRO}-twist-mux \
    libjsoncpp-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR ${WORKSPACE}
RUN . /opt/ros/${ROS_DISTRO}/setup.sh \
 && python3 -m colcon build --symlink-install --packages-ignore \
    tuw_rviz

COPY ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["ros2", "run", "tuw_gamepad", "gamepad_node", \
     "--ros-args", \
       "-p", "use_stamped_velocity:=true", \
       "-p", "debug:=true", \
       "-p", "lx:=3", \
       "-p", "az:=0", \
       "-p", "flip_angular_when_reversing:=true", \
       "-p", "scale_linear:=-2.0", \
       "-p", "scale_angular:=-2.0"]
       
