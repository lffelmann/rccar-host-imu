ARG ROS_DISTRO=jazzy
FROM ros:${ROS_DISTRO}

RUN apt-get update && apt-get install -y \
  git \
  python3-colcon-common-extensions \
  python3-rosdep \
  && rm -rf /var/lib/apt/lists/*

ENV WORKSPACE=/opt/ros2_ws
RUN mkdir -p ${WORKSPACE}/src
WORKDIR ${WORKSPACE}/src

RUN git clone https://github.com/lffelmann/rccar.git \
  && git clone https://github.com/lffelmann/rccar_msgs.git 

RUN rosdep init || true && rosdep update

WORKDIR ${WORKSPACE}
RUN . /opt/ros/${ROS_DISTRO}/setup.sh \
  && rosdep install --from-paths src --ignore-src -r -y \
  && python3 -m colcon build --symlink-install 

COPY ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
ENTRYPOINT ["/ros_entrypoint.sh"]
