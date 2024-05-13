FROM builder:latest
WORKDIR /tesseract.js-node
RUN npm test
