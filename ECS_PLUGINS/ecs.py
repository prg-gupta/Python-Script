import boto3
import pprint
import json
import sys
import argparse

access_key = "KEY"
secret_key = "Secrete"
REGION_NAME = None
IMAGE_VERSION = None
TASK_DEFINITION_NAME = None


response = None

def reg_task_definition():
	'''
	Get the task definiatin and update the new image in json , Register the defination 
	'''
	try :

    		ecs_client = boto3.client('ecs',aws_access_key_id=access_key,aws_secret_access_key=secret_key,region_name=REGION_NAME)
	except:
		print "Could not able to connect to ECS"
		sys.exit(1)

    	try :
		response = ecs_client.describe_task_definition(taskDefinition=TASK_DEFINITION_NAME)
	except:
		print "Could not find the task definition"
		sys.exit(1)

	t_role_arn =  response['taskDefinition']['taskRoleArn']
	t_family= response['taskDefinition']['family']

	 
	response['taskDefinition']['containerDefinitions'][0]['image'] = IMAGE_VERSION

	container_definition = response['taskDefinition']['containerDefinitions']
        
        res = None
    	try :
		res = ecs_client.register_task_definition(family=t_family,taskRoleArn=t_role_arn,containerDefinitions=container_definition)
                return res         
	except:
                
		print "register_task_definition failed"
		sys.exit(1)	
        
	



def main():
  desc = 'Update container image version in taskDefinition'
  parser = argparse.ArgumentParser(description=desc)
  parser.add_argument('-r', '--region', help='AWS region. Default: us-west-1',default='us-west-2',required=True)
  parser.add_argument('--image_version',type=str,default='dummy',required=True)
  parser.add_argument('--task_defi_name',type=str,default='dummy',required=True)

  
  args = parser.parse_args()

  global REGION_NAME
  global IMAGE_VERSION
  global TASK_DEFINITION_NAME
  IMAGE_VERSION = args.image_version
  REGION_NAME = args.region
  TASK_DEFINITION_NAME = args.task_defi_name
  print TASK_DEFINITION_NAME
  print IMAGE_VERSION
  print REGION_NAME
  output = reg_task_definition()

  print output

main()
