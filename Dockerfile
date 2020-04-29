# Use official Ubuntu 18.04 base image
FROM ubuntu:18.04

# Install prerequisites
# curl: download ModusToolbox.tar.gz
# git: download ModusToolbox project
# make: build ModusToolbox projects
# file: called by make/getlibs.bash
# libglib2.0-0: Qt Configurators depend on libglib-2.0.so.0
# libusb-0.1-4: recommended in the README
# libusb-1.0-0: OpenOCD, fw-loader, CapSense Tuner and DFU Host Tool depend in libusb-1.0.so.0
# libgl1-mesa-glx: Qt Configurators depend on libGLX.so.0
# libfontconfig1: bin/platforms/libqoffscreen.so depends on libfontconfig.so.1 and libfreetype.so.6
RUN apt update -y \
 && apt install -y curl git make file libglib2.0-0 libusb-0.1-4 libusb-1.0-0 libgl1-mesa-glx libfontconfig1 \
 && apt clean

# Download and extract ModusToolbox software
RUN curl --fail --location --silent --show-error http://dlm.cypress.com.edgesuite.net/akdlm/downloadmanager/software/ModusToolbox/ModusToolbox_2.1/ModusToolbox_2.1.0.1266-linux-install.tar.gz -o /tmp/ModusToolbox_2.1.0.1266-linux-install.tar.gz \
 && tar -C /opt -zxf /tmp/ModusToolbox_2.1.0.1266-linux-install.tar.gz \
 && rm /tmp/ModusToolbox_2.1.0.1266-linux-install.tar.gz

# Execute post-build scripts
# Note:  udev does not support containers, install_rules.sh not executed
RUN bash -e /opt/ModusToolbox/tools_2.1/modus-shell/postinstall
# && sudo bash -e /opt/ModusToolbox/tools_2.1/openocd/udev_rules/install_rules.sh \
# && sudo bash -e /opt/ModusToolbox/tools_2.1/driver_media/install_rules.sh \
# && sudo bash -e /opt/ModusToolbox/tools_2.1/fw-loader/udev_rules/install_rules.sh

# Set environment variable required by ModusToolbox application makefiles
ENV CY_TOOLS_PATHS="/opt/ModusToolbox/tools_2.1"
# Set environment variable to enable running Qt-based CLI tools in headless environment
ENV QT_QPA_PLATFORM="offscreen"
# Set environment variable to avoid Qt warning
ENV XDG_RUNTIME_DIR="/tmp"
