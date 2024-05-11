ARG BUILDER_VERSION

FROM utt-builder:${BUILDER_VERSION}

# Create a script to execute utt commands and sleep
RUN echo '#!/bin/bash' >> /entrypoint.sh \
    && echo 'utt hello' >> /entrypoint.sh \
    && echo 'sleep 65' >> /entrypoint.sh \
    && echo 'utt add "DevOps"' >> /entrypoint.sh \
    && echo 'exec "$@"' >> /entrypoint.sh \
    && chmod +x /entrypoint.sh

# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Default command to run when the container starts
CMD ["utt", "report"]
