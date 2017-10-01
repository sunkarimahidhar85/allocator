import subprocess
import json
from flask import Flask, request, after_this_request, jsonify
import requests
import random
import sys
import csv
import threading
from time import gmtime, strftime

app = Flask(__name__)

global index
global max_index
global data
global output_file
global output_filewriter
global allocated_data

@app.route('/whoami')
def whoami():
  return jsonify({"whoami_ip": request.remote_addr})

@app.route('/allocate')
def allocate():
  global index
  global data

  lock = threading.Lock()

  lock.acquire()
  time = strftime("%Y-%m-%d-%H:%M:%S", gmtime())
  if (index <= max_index):
    override = request.args.get('override', 'true')
    if (request.remote_addr in allocated_data and override == 'false'):
      datum = "ERROR_DUPLICATE_ALLOCATION_REQUEST"
    else:
      datum = data[index][0]
  else:
    datum = "ERROR_MAX_INDEX_REACHED"

  print("(%s, %s, %s, %s)" % (time, request.remote_addr, index, datum))

  output_filewriter.writerow([time, request.remote_addr, index, datum])
  output_file.flush()

  json_result = jsonify({"allocation": datum}, {"index": index}, {"time": time})

  if (datum not in ("ERROR_DUPLICATE_ALLOCATION_REQUEST", "ERROR_MAX_INDEX_REACHED")):
    allocated_data[request.remote_addr] = datum
    index = index + 1

  lock.release()

  return json_result

@app.route('/close')
def close():
  output_file.close()
  return jsonify({"OK"})

@app.route('/allocations')
def allocations():
  allocated_filename = "allocated_data.csv"
  allocated_file = open(allocated_filename, 'rt')
  allocations = list(csv.reader(allocated_file))
  transformed_allocations = [{'index': allocation[2], 'ip': allocation[3]} for allocation in allocations]
  allocated_file.close()

  return jsonify(transformed_allocations)

@app.route('/allocation/<ip>')
def allocation(ip):
  allocated_filename = "allocated_data.csv"
  allocated_file = open(allocated_filename, 'rt')
  allocations = list(csv.reader(allocated_file))
  transformed_allocations = [{'index': allocation[2], 'ip': allocation[3]} for allocation in allocations if allocation[3].replace('[','').replace(']','') == ip]
  allocated_file.close()

#  allocations_json = json.loads(transformed_allocations)
  if (len(transformed_allocations) > 0):
    return jsonify(transformed_allocations[0])
  else:
    return jsonify({})

if __name__ == '__main__':
  global index
  global max_index
  global output_file
  global output_filewriter
  global data
  global allocated_data

  input_filename = "data.csv"

  input_file = open(input_filename, 'rt')

  data = list(csv.reader(input_file))
  max_index = len(data) - 1
  input_file.close()

  allocated_data = {}

  allocated_filename = "allocated_data.csv"
  allocated_file = open(allocated_filename, 'rt')
  allocated_list = list(csv.reader(allocated_file))
  start_index = len(allocated_list)
  allocated_file.close()

  lock = threading.Lock()
  lock.acquire()
  index = start_index
  lock.release()

  for datum in data:
    print(datum)

  output_filename = "allocated_data.csv"
  output_file = open(output_filename, 'at')
  output_filewriter = csv.writer(output_file)

  app.run(host='0.0.0.0', port='5070')
