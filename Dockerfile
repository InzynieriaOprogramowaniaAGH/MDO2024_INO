# Dockerfile
FROM redis:latest

# Expose default Redis port
EXPOSE 6379

# Command to run Redis server
CMD ["redis-server"]
