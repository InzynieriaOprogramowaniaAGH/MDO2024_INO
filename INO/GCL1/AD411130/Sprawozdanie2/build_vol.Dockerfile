FROM node


RUN mkdir in
RUN mkdir out


RUN --mount=type=bind,source=input_vol,target=/in,rw
RUN --mount=type=bind,source=output_vol,target=/out,rw

WORKDIR /in

RUN git clone https://github.com/gcedo/eventsourcemock.git
WORKDIR /in/eventsourcemock
RUN npm install -g npm@10.5.1
RUN cp -r src ../out/src1
