#!/usr/bin/ruby

# Include the ruby clinet for riak
require 'riak'
require 'pp'

# Connect to our riak client
client = Riak::Client.new(host: '172.30.0.58', :pb_port => 8087)
# Specify which bucket to use
bucket = client.bucket('loopdata3')

#Query the data
q = Riak::SecondaryIndex.new(bucket, 'speed_int', 100..1000)

count = q.values.count

pp "The total count of cars going over 100: #{count}"
