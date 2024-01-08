FROM deitos-base-image

ENV KRB5CCNAME=/tmp/krb5cc

COPY run.sh /usr/local/sbin/run.sh
RUN sudo chmod a+x /usr/local/sbin/run.sh
CMD ["run.sh"]