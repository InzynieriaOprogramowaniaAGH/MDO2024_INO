FROM utt-builder

# Create a directory to store the report
RUN mkdir -p /var/www/html

# Create a script to execute utt commands and start a simple HTTP server
RUN echo '#!/bin/bash' >> /entrypoint.sh \
    && echo 'utt hello' >> /entrypoint.sh \
    && echo 'utt add "DevOps"' >> /entrypoint.sh \
    && echo 'utt report > /var/www/html/index.html' >> /entrypoint.sh \
    && echo 'cd /var/www/html' >> /entrypoint.sh \
    && echo 'python3 -m http.server 8000' >> /entrypoint.sh \
    && chmod +x /entrypoint.sh

# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Expose the HTTP port
EXPOSE 8000

# Default command to run when the container starts
CMD ["utt", "report"]
