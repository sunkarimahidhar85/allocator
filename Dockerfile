FROM 954636985443.dkr.ecr.us-west-2.amazonaws.com/pipelineai/ubuntu-16.04-cpu:master

RUN \
  pip install --upgrade pip

RUN \
  pip install flask requests

WORKDIR /root

COPY allocator.py allocator.py 
COPY allocated_data.csv allocated_data.csv
COPY data.csv data.csv
COPY run run 

EXPOSE 5070 

CMD ["supervise", "."]
