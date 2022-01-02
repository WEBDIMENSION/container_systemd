FROM webdimension/centos7_systemd:latest

# ssh key
RUN mkdir -m 700 /home/master/.ssh
RUN chown -R master:master /home/master/.ssh/
ADD ansible_rsa.pub /tmp/public_key
RUN cat /tmp/public_key >> /home/master/.ssh/authorized_keys \
  && chmod 600 /home/master/.ssh/authorized_keys \
  && chown master:master /home/master/.ssh/authorized_keys \
  && rm -f /tmp/public_key

