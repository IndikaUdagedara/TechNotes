## Cloudwatch
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