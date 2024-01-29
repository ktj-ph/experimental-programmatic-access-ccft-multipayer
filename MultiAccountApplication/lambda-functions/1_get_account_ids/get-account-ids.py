import boto3
import os
import json

def lambda_handler(event, context):
    bucket = os.environ['bucketName']
    file_key = os.environ['fileKey']

    s3_client = boto3.client('s3')

    # Get the account ID where the Lambda function is running in
    account_id = context.invoked_function_arn.split(":")[4]

    try:
        # Download the JSON file from S3
        response = s3_client.get_object(Bucket=bucket, Key=file_key)
        json_content = response['Body'].read().decode('utf-8')

        # Parse the JSON content
        account_ids = json.loads(json_content)
    
    except Exception as e:
        print(f"Error: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('Error processing account IDs')
        }
    

    return {
        'statusCode': 200,
        'account_ids': account_ids,
        'account_id': account_id
    }
