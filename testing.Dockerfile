ARG ROS_DISTRO=jazzy
FROM ros:${ROS_DISTRO}

RUN apt-get update && apt-get install -y \
  git \
  tmux \
  python3-colcon-common-extensions \
  python3-rosdep \
  ros-${ROS_DISTRO}-rosbag2 \
  && rm -rf /var/lib/apt/lists/*

RUN echo "set -g mouse on" >> /root/.tmux.conf

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
