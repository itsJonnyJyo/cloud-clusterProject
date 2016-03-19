#!/usr/bin/ruby

require 'riak'
require 'pp'


#get connection to riak node
client = Riak::Client.new(host: '172.30.0.58', :pb_port => 8087)

#create object of stations bucket
detectors = client.bucket('stations2')

#create SecondaryIndex object for the results of a search on
#one of our '2i' secondary indexes
q = Riak::SecondaryIndex.new detectors, 'location_bin', 'Foster NB'
#store detectorid associated with the location
#would need to loop and push into array if we had multiple
detector_key = q.values[0].data['detectors']['detectorid']

#create bucket object for loopdata bucket
loopdata = client.bucket('loopdata2')

#same as first SecondaryIndex but search on 'dectorId_bin' index
#in loopdata bucket. Match whatever is in detector_key
z = Riak::SecondaryIndex.new loopdata, 'dectorId_bin', detector_key



volume = 0
#pp z.values.size
#
#for all loopdata entries at the specified detectorids/detector-key
z.values.each do |x|
   str = (x.data['starttime']).to_s
   #utilizing 'one day of loopdata' which doesn't include 9/21/2011
   if str.include? "9/15/2011"
      #volume.push((x.data['volume']).to_i)
      volume += x.data['volume'].to_i
   end
end


puts "The total volume on the speciied date was: #{volume} "



