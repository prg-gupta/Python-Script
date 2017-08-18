#!/usr/bin/python


import boto
import boto.ec2.elb
import boto.utils
from boto.ec2.elb import connect_to_region
import argparse
import sys

instance_count = 0
AWS_PROFILE = None
ELB_NAME = None
REGION_NAME = None 

def getInstancesFromElb():
  '''
  This functions takes elb name as argument and return a dictionary consists of instance id and their state
  '''
  instance_state = {}
  el = connect_to_region(profile_name=AWS_PROFILE,region_name=REGION_NAME)

  for instance in el.describe_instance_health(ELB_NAME):
    instance_state[instance.instance_id]=instance.state

  return instance_state



def main():
  desc = 'Check Elb instances'
  parser = argparse.ArgumentParser(description=desc)
  parser.add_argument('-r', '--region', help='AWS region. Default: us-west-1',default='us-west-1',required=True)
  parser.add_argument('--aws_profile',type=str,default='icinga_rds_check',required=True)
  parser.add_argument('--elb_name',type=str,default='None',required=True)
  parser.add_argument('--num_of_instances',type=int,default='2',required=True)
  
  args = parser.parse_args()
  print args.elb_name

  global AWS_PROFILE
  global ELB_NAME
  global REGION_NAME
  
  AWS_PROFILE = args.aws_profile
  ELB_NAME = args.elb_name
  REGION_NAME = args.region


  instance_state=getInstancesFromElb()
  reg_instaces_cn = 0


  if (len(instance_state) > 0):
    for key,value in instance_state.items():
      reg_instaces_cn = reg_instaces_cn + 1
 
      if(value == "OutOfService") :
        print "instance : "+str(key)+" is unhealthy"
        sys.exit(2)    

    if reg_instaces_cn == args.num_of_instances:
      print "All Instances are attached and Healthy"
    else :
      print "Please attach missing instance to ELB "
      sys.exit(1)

  else:
    print "0 instances are registered to ELB : " +str(ELB_NAME)
    sys.exit(2)

main()

