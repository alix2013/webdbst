FROM ubuntu:22.04
RUN apt-get update && \
    apt-get install -y shellinabox \
    openssh-server passwd net-tools vim wget curl lsof git \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN echo "root:passw0rd123!@#" | chpasswd  

RUN useradd -m -d /home/web web 
RUN echo "web:passw0rd123!@#" | chpasswd  

RUN git clone https://github.com/alix2013/tools.git /home/web/tools
RUN chown -R web /home/web/tools
RUN chmod 700 /home/web/tools


COPY start.sh /start.sh 
RUN chmod a+x /start.sh

EXPOSE 4200
ENTRYPOINT ["/start.sh"]
CMD []


