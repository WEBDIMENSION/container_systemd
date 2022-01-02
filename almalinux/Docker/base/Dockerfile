FROM almalinux/almalinux
RUN dnf -y update; dnf clean all
RUN dnf -y install openssh-server passwd;
RUN systemctl enable sshd
# Dnf Install
RUN dnf install -y \
  sudo \
  which \
  unzip \
  vim \
  git \
  firewalld \
  cronie-noanacron \
  iproute \
  openssh-clients

RUN dnf -y install python36
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN pip3 install --upgrade pip
RUN dnf install -y --enablerepo epel-playground ansible


## User Add
RUN useradd master
RUN echo 'master:password' | chpasswd
RUN echo "master ALL=NOPASSWD: ALL" >> /etc/sudoers

# sshd_config
RUN sed -i'' -e's/^#PermitRootLogin prohibit-password$/PermitRootLogin no/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^#PubkeyAuthentication yes$/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^PasswordAuthentication yes$/PasswordAuthentication no/' /etc/ssh/sshd_config \
        && sed -i'' -e's/^#PermitEmptyPasswords no$/PermitEmptyPasswords no/' /etc/ssh/sshd_config
# root pasword
RUN echo 'root:password' | chpasswd

# Open ssh port
EXPOSE 22

# host key
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
# EntryPoint
ENTRYPOINT ["/sbin/init"]
