FROM node
RUN git clone https://github.com/codeclown/tesseract.js-node.git
WORKDIR /tesseract.js-node
RUN npm install