I enabled AWS Free Tier usage alerts to automatically notify me when my resource usage approaches the Free Tier limits. 
I also created a CloudWatch Billing Alarm (in us-east-1) that triggers when my estimated monthly charges exceed ₹100. 
The alarm sends an email alert through SNS, helping monitor unexpected spending. 
This setup ensures I stay within the free tier and avoid accidental charges, which is especially important for beginners.

# Task 4 – Billing & Free Tier Cost Monitoring

## Explanation
I enabled AWS Free Tier usage alerts to monitor free-tier resource consumption. 
Then I created a CloudWatch Billing Alarm in the us-east-1 region that sends an SNS email notification when estimated monthly billing exceeds ₹100 (approx. $1.20). 
This helps prevent unexpected AWS charges and ensures safe usage for beginners. 

## Screenshots
- BillingAlarm.png  
- FreeTierAlert.png  

## Notes
Billing alarms and free-tier alerts cannot be created using Terraform; these actions require manual setup in the AWS Console.
