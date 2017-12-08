FROM pipelineai/ubuntu-16.04-cpu:master

RUN \
  pip install flask requests

WORKDIR /root

COPY allocator.py allocator.py 
COPY allocated_data.csv allocated_data.csv
COPY data.csv data.csv
COPY run run 
COPY scripts scripts

EXPOSE 5070 

CMD ["supervise", "."]
