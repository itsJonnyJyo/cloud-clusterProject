#!/usr/bin/ruby

require 'riak'
require 'pp'

#Get connection to riak node
client = Riak::Client.new(host: '172.30.0.58', :pb_port => 8087)

#create bucket object for stations bucket
stations = client.bucket('stations2')

#get data at specified key
fetched = stations.get('1045')
update = stations.get('1045')

#update and save
update.data['length'] = '2.3'
update.store

#print previous and updated data from specified key
pp fetched.data
pp update.data
