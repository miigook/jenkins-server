Update a records in Route53 every time  instance starts with new IP

- Lambda function
- EventBridge


Lambda Function in Python

```python
import boto3
import os
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # Extract instance ID from the EventBridge event
    instance_id = event['detail']['instance-id']
    logger.info(f"Instance started: {instance_id}")

    # Initialize AWS clients
    ec2_client = boto3.client('ec2')
    route53_client = boto3.client('route53')

    # Get the public IP of the instance
    try:
        response = ec2_client.describe_instances(InstanceIds=[instance_id])
        instance = response['Reservations'][0]['Instances'][0]
        
        if 'PublicIpAddress' not in instance:
            logger.error("Public IP not yet assigned to the instance")
            return {'status': 'error', 'message': 'Public IP not available'}
        
        public_ip = instance['PublicIpAddress']
        logger.info(f"Public IP retrieved: {public_ip}")
    except Exception as e:
        logger.error(f"Error retrieving public IP: {e}")
        raise

    # Get hosted zone ID and record names from environment variables
    hosted_zone_id = os.environ.get('HOSTED_ZONE_ID')
    record_names = [name.strip() for name in os.environ.get('RECORD_NAMES').split(',')]
    
    # Log the records to be updated
    logger.info(f"Updating records: {', '.join(record_names)} to IP: {public_ip}")
    
    # Create change batch for multiple records
    change_batch = {
        'Changes': [
            {
                'Action': 'UPSERT',
                'ResourceRecordSet': {
                    'Name': record_name,
                    'Type': 'A',
                    'TTL': 300,
                    'ResourceRecords': [{'Value': public_ip}]
                }
            } for record_name in record_names
        ]
    }
    
    # Update Route 53
    try:
        route53_client.change_resource_record_sets(
            HostedZoneId=hosted_zone_id,
            ChangeBatch=change_batch
        )
        logger.info(f"Route 53 A records updated: {', '.join(record_names)} -> {public_ip}")
        return {'status': 'success'}
    except Exception as e:
        logger.error(f"Error updating Route 53: {e}")
        raise
```

#EvenBridge Rule

```json
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["running"],
    "instance-id": ["i-09dc450a1532cdd03"]
  }
}
```

#IAM Role Execution for lambda

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:us-east-1:<accountID>:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:us-east-1:<accountID>:log-group:/aws/lambda/Route53ipChange:*"
            ]
        },
        {
            "Sid": "EC2InstanceIptoGET",
            "Effect": "Allow",
            "Action": "ec2:DescribeInstances",
            "Resource": "*"
        },
        {
            "Sid": "Route53TochangeIP",
            "Effect": "Allow",
            "Action": "route53:ChangeResourceRecordSets",
            "Resource": "arn:aws:route53:::hostedzone/<hosted-zoneID>"
        }
    ]
}
```

Lastly in EC2 Instance set cronjob

sudo timedatectl set-timezone America/Chicago

sudo crontab -e 

`0 22 * * * shutdown -h now` this will shutdown ec2 instance 10 PM everyday in case you forget to stop your instance