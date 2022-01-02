FROM centos:centos7
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]
# dnf update
RUN yum -y update; yum clean all
# sshd install
RUN yum -y update; yum clean all
RUN yum -y install openssh-server passwd; yum clean all
RUN systemctl enable sshd
RUN yum install -y openssh-clients
# Install tools
RUN yum install -y \
  sudo \
  which \
  unzip \
  vim \
  git \
  firewalld \
  cronie-noanacron \
  iproute \
  openssh-clients

RUN yum install -y https://repo.ius.io/ius-release-el7.rpm

## user add
RUN useradd master
RUN echo 'master:password' | chpasswd
RUN echo "master ALL=NOPASSWD: ALL" >> /etc/sudoers

# sshd_config
RUN sed -i'' -e's/^#PermitRootLogin prohibit-password$/PermitRootLogin no/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^#PubkeyAuthentication yes$/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^#PasswordAuthentication yes$/PasswordAuthentication no/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^#PermitEmptyPasswords no$/PermitEmptyPasswords no/' /etc/ssh/sshd_config
# change root passeord
RUN echo 'root:password' | chpasswd

# open ssh port
EXPOSE 22

# host key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''

## EntoryPoint
#ENTRYPOINT ["/sbin/init"]
CMD ["/sbin/init"]
