ARG ROS_DISTRO=jazzy
FROM ros:${ROS_DISTRO}

RUN apt-get update && apt-get install -y \
     python3-colcon-common-extensions \
     git \
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
 && colcon build --symlink-install --packages-ignore \
    tuw_rviz

COPY ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
