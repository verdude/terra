from fastapi import FastAPI
import boto3
from botocore.exceptions import NoCredentialsError

def s3_put_get_presign(bucket_name, object_key, object_data):
    # Create an S3 client
    s3_client = boto3.client('s3')

    try:
        # Put an object
        s3_client.put_object(Bucket=bucket_name, Key=object_key, Body=object_data)

        # Get the object
        response = s3_client.get_object(Bucket=bucket_name, Key=object_key)
        print("Object content:", response['Body'].read())

        # Generate a pre-signed URL for the object
        presigned_url = s3_client.generate_presigned_url('get_object',
                                                         Params={'Bucket': bucket_name, 'Key': object_key},
                                                         ExpiresIn=3600)
        print("Pre-signed URL:", presigned_url)
        return presigned_url
    except NoCredentialsError:
        print("Credentials not available")
    except Exception as e:
        print(f"An error occurred: {e}")

# Example usage
bucket = 'elasticbeanstalk-us-east-1-837443695054'
key = 'hardyhar'
data = 'Hello, World!'

app = FastAPI()

@app.get("/")
def root():
    return "wow, ok."

@app.get("/s3")
def s3():
    return s3_put_get_presign(bucket, key, data)
