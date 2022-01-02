FROM webdimension/amazonlinux2_systemd:latest
# install amazon-linux-extras install
# ssh key
RUN mkdir -m 700 /home/ec2-user/.ssh
RUN chown -R ec2-user:ec2-user /home/ec2-user/.ssh/
ADD ansible_rsa.pub /tmp/public_key
RUN cat /tmp/public_key >> /home/ec2-user/.ssh/authorized_keys \
  && chmod 600 /home/ec2-user/.ssh/authorized_keys \
  && chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys \
  && rm -f /tmp/public_key
