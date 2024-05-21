FROM dummy-build
WORKDIR /root/dummy
EXPOSE 3000
CMD ["npm", "start"]
