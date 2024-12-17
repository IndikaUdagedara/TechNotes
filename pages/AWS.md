## RDS
	- IAM auth
		- MySQL
		  ```
		  aws rds generate-db-auth-token --hostname rds-cdata-preprod-v1.c9yv7rfnzgng.ap-southeast-2.rds.amazonaws.com --port _3306_ --region _ap-southeast-2_ --username _master_
		  ```
		     
		  ```
		  mysql --host=rds-cdata-preprod-v1.c9yv7rfnzgng.ap-southeast-2.rds.amazonaws.com --port=3306 --ssl-ca=/root/global-bundle.pem --enable-cleartext-plugin --user=master --password=<authToken>
		  ```
- ## EC2
	- Port forwarding
		- ```
		  Instance_id=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=awscdatapreprod01" --query "Reservations[0].Instances[0].InstanceId" --output text)
		  aws ssm start-session --target $instance_id --document-name AWS-StartPortForwardingSession --parameters '{"portNumber":["8080"],"localPortNumber":["8080"]}'
		  ```
	-
- ## Step functions
![Pasted_image_20241123171741.png](../assets/Pasted_image_20241123171741.png)

JSON path from input to be sent to task
 
Input: {"a": 123, "b": 456}  
InputPath: $.b￼  
This means only {"b": 456} is sent to task

Key, value sent to AWS integration
 
If value contains a JSON path, key should end with .$￼￼Parameters: { "somekey": "static value",  
"fromJsonPath.$": $.b}
 
Assume task returns
 
{"pqr": 456, "xxx": 789}

Selects values from the task result.  
Can be static or contain JSON path from task result
 
ResultSelector: {"otherKey": "static value", "fromJsonPath.$": $.pqr}

If ResultPath is empty or $, result becomes the output
 
ResultPath: $  
Output: {"otherKey": "static value", "fromJsonPath.$": 456}
   

If ResultPath is a JSONPath output is inserted into input
 
ResultPath: $.TaskResult  
Output: {"a": 123, "b": 456, "TaskResult": {"otherKey": "static value", "fromJsonPath.$": 456}}

Input to AWS service/worker:  
{ "somekey": "static value",  
"fromJsonPath": 456}

Filter to apply to output after applying ResultPath
 
OutputPath: $.a  
Output: {"a": 123}

-
- ## Stax
  
  `stax2aws login -i stax-au1 -o versent-innovation -r  arn:aws:iam::272435851616:role/staxid-admin-role`
-
-
- ## Cloudwatch
- ### Log Insights
  
  
  ```
  fields @message  
  | filter @message like /Executed action ".*in/  
  | parse @message "in *ms" as duration  
  | filter duration > 10000.0  
  | limit 10
  ```
- ### expensive request
  
  ```
  filter @message like /Executed action ".*in/  
  | parse @message "\"*\" in *ms" as action, duration  
  | sort duration desc  
  | limit 10
  
  ```
- ### count of requests  
  
  ```
  fields @message  
  | filter @message like /Executed action ".*in/  
  | parse @message "in *ms" as duration  
  | filter duration > 10000.0  
  | limit 10
  ```
- ### text logs
   
  ```
  fields @message  
  | filter @message like /Executed action ".*in/  
  | parse @message "in *ms" as duration  
  | filter duration > 10000.0  
  | limit 10
  ```
  
  ```
  fields @message  
  | filter @message like /Executed action ".*in/  
  | parse @message "in *ms" as duration  
  | filter duration > 10000.0  
  | limit 10
  ```
- ### group by action
  
  ```
  fields @message  
  | filter @message like /Executed action ".*in/  
  | parse @message "in *ms" as duration  
  | filter duration > 10000.0  
  | limit 10
  ```