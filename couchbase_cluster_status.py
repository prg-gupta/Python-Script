#!/usr/bin/python
import json
import pycurl
import cStringIO
import os
import sys
import argparse

#**************************Functions Defination ***************************************
def Get_Couchibase_Ips(env_name):
  '''Get the Envriment json file '''
  env_json_data = ''
  knife_cmd = "knife environment show "+ env_name + " -f json"
  var = os.popen(knife_cmd).read()
  env_json_data = Json_Parse(var)
  return  env_json_data['default_attributes']['global']['couchbase']['hosts']
  

def Couchbase_json(ips,user,password):
  '''Get the Couchbase clustors details in Json'''
  count = 0 
  #test
  buf = cStringIO.StringIO()  
  couchbase_url = "http://"+ips+":8091/pools/default"
  user_pwd = str(str(user)+":"+str(password))
  c = pycurl.Curl()
  c.setopt(c.URL, couchbase_url)
  c.setopt(c.USERPWD, user_pwd)
  c.setopt(c.WRITEFUNCTION, buf.write)
  c.setopt(c.CONNECTTIMEOUT,30)
  try:
    c.perform()
    if( c.getinfo(pycurl.HTTP_CODE)!= 200 ):
      print "Warning : for "+str(ips)+ " status code is :"+ str(c.getinfo(pycurl.HTTP_CODE))
      sys.exit (1)
  except Exception, err:
    print  "CRITICAL: for "+ str(ips) + " : "+str(err) 
    sys.exit(2)

  jsonstring =  buf.getvalue()
  buf.close()
  return jsonstring

def Json_Parse(jstr):
  '''Parse json Content'''
  data = ''
  data = json.loads(jstr)
  return data

def Get_nodes_no(jdata):
  '''Get the nodes  count and details'''
  checker = False
  unhealthy_nodes = []
  for i in range(len(jdata['nodes'])):
    	
    if(jdata['nodes'][i]['status'] !='healthy'):
      unhealthy_nodes.append[str(jdata['nodes'][i]['hostname'])]
      checker = True	
    else:
      continue	
  
  if(checker):
    print "CRITICAL :Couchbase clustors node "+','.join(unhealthy_nodes)+" is :"+str(jdata['nodes'][i]['status'])
    sys.exit(2)
  else:
    print "OK : All nodes in cluster are healthy and number of node in cluster :"+str(len(jdata['nodes']))
    sys.exit(0)  

#********************** Functions ************************************************************************

def parse_cmdline(args):
  desc = 'Check Audiobridge partner sip'
  parser = argparse.ArgumentParser(description=desc)
  parser.add_argument('-u', '--user', help='user of couchbase',type=str, required=True)
  parser.add_argument('-p', '--password', help='password of couchbase',type=str, required=True)
  parser.add_argument('-i', '--ip', help='ip  of couchbase node',type=str, required=True)
  args = parser.parse_args()

  return args

if __name__ == '__main__':
  args = parse_cmdline(sys.argv)


json_string = Couchbase_json(args.ip,args.user,args.password)


json_data = Json_Parse(json_string)

Get_nodes_no(json_data)

