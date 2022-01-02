FROM amazonlinux:2

# install amazon-linux-extras install
RUN amazon-linux-extras install -y

# yum update & install
RUN yum install -y \
  systemd \
  sudo \
  which \
  unzip \
  vim \
  git \
  firewalld \
  cronie-noanacron \
  iproute \
  openssh-clients


RUN yum -y update; yum clean all
RUN yum -y install openssh-server passwd; yum clean all
RUN systemctl enable sshd
# install aws cli v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install

# create user
RUN useradd "ec2-user" && echo "ec2-user ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN sed -i'' -e's/^#PermitRootLogin prohibit-password$/PermitRootLogin no/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^#PubkeyAuthentication yes$/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^#PasswordAuthentication yes$/PasswordAuthentication no/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^#PermitEmptyPasswords no$/PermitEmptyPasswords no/' /etc/ssh/sshd_config

# install for develop, etc.
RUN sudo amazon-linux-extras install golang1.11 -y

# init
CMD ["/sbin/init"]
