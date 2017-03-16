FROM centos:latest

RUN yum -y update 

RUN yum -y install wget which sudo openssh-server openssh-clients
RUN yum -y install ntp
	
RUN wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -ivh epel-release-latest-7.noarch.rpm

RUN yum -y groupinstall 'Development Tools'

RUN yum -y install openmpi-devel cmake redhat-lsb-core

RUN yum -y install \
	libXi-devel libXmu-devel libXrandr-devel  \
    libXinerama-devel libXcursor-devel mesa-libGLU-devel mesa-libGL-devel libX11
    
RUN yum -y install \
	libjpeg-turbo-devel leveldb-devel openblas-devel  \
    snappy-devel opencv-devel boost-devel gflags-devel glog-devel  \
    lmdb-devel libpng-devel freetype-devel bc

RUN useradd -ms /bin/bash builder
RUN mkdir -p /home/builder/.ssh
RUN chmod 700 /home/builder/.ssh
RUN mkdir -p /home/builder/rpmbuild/RPMS
RUN mkdir -p /home/builder/rpmbuild/RPMS/BUILD
RUN mkdir -p /home/builder/rpmbuild/RPMS/BUILDROOT
RUN mkdir -p /home/builder/rpmbuild/RPMS/RPMS
RUN mkdir -p /home/builder/rpmbuild/RPMS/SOURCES
RUN mkdir -p /home/builder/rpmbuild/RPMS/SPECS
RUN mkdir -p /home/builder/rpmbuild/RPMS/SRPMS

RUN chown -R builder:builder /home/builder


RUN echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/openmpi/lib" > /home/builder/.bashrc
RUN echo "export PATH=$PATH:/usr/lib64/openmpi/bin" >> /home/builder/.bashrc

RUN usermod -aG wheel builder
RUN sed -i 's/^#[ \t]*%wheel[ \t]*ALL=(ALL)[ \t]*NOPASSWD:[ \t]*ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
RUN sed -i 's/.el7.centos/.el7/' /etc/rpm/macros.dist



USER builder
WORKDIR /home/builder