FROM jenkins/jnlp-slave
COPY start.sh start.sh
COPY nodeTemplate.json nodeTemplate.json
USER 0
RUN chmod +x /home/jenkins/start.sh


ENTRYPOINT ["/home/jenkins/start.sh"]
