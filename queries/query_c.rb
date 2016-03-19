#!/usr/bin/ruby


require 'riak'
require 'pp'

# Connect to the riak client and specify the bucket we need
client = Riak::Client.new(host: '172.30.0.58', :pb_port => 8087)
bucket = client.bucket('stations3')

# Execute a direct match query
q = Riak::SecondaryIndex.new(bucket, 'location_bin', 'Foster NB')

detectorId = q.values[0].data['detectors']['detectorid']
length     = q.values[0].data['length'].to_f

loopsBucket = client.bucket('loopdata3')

# Execute a Range query to get AM loops
q1 = Riak::SecondaryIndex.new(loopsBucket, 'startime_bin', '9/15/2011 7'..'9/15/2011 9')

# We needed to iterate over the data to see where detectorId
# Matched
amTotalSpeed = 0;
count = 0;
q1.values.each do |x|
  if x.data['detectorid'] == detectorId
    amTotalSpeed += x.data['speed'].to_f
    count += 1
  end
end

averageSpeed = amTotalSpeed / count.to_f

amTravelTime = (length / averageSpeed) * 3660

pp "Average travel time in seconds for 7-9AM #{amTravelTime}"


q2 =  Riak::SecondaryIndex.new(loopsBucket, 'startime_bin', '9/15/2011 16:'..'9/15/2011 18:')

pmTotalSpeed = 0;
count = 0;
averageSpeed = 0;
q2.values.each do |x|
  if x.data['detectorid'] == detectorId
    if x.data['speed'] != nil
      pmTotalSpeed += x.data['speed'].to_f
      count += 1
    else
      pmTotalSpeed += x.data['speed'].to_f
      count += 1 
    end
  end
end

averageSpeed = pmTotalSpeed / count.to_f

pmTravelTime = (length / averageSpeed) * 3600

pp "Average travel time in seconds for 4-6PM #{pmTravelTime}"
