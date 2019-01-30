FROM alpine:latest

RUN touch /bin/hey && chmod 755 /bin/hey \
    && echo "#!/bin/sh" > /bin/hey && echo "echo hey" >> /bin/hey

CMD ["/bin/hey"]
