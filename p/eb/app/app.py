from fastapi import FastAPI
import boto3
from botocore.exceptions import NoCredentialsError
from aiobotocore.session import get_session

async def s3_put_get_presign(bucket_name, object_key, object_data):
    try:
        session = get_session()
        async with session.create_client('s3') as s3_client:
            await s3_client.put_object(Bucket=bucket_name, Key=object_key, Body=object_data)
            response = await s3_client.get_object(Bucket=bucket_name, Key=object_key)
            print(response)
            presigned_url = await s3_client.generate_presigned_url(
                'get_object',
                Params={'Bucket': bucket_name, 'Key': object_key},
                ExpiresIn=3600,
            )
            return presigned_url
    except NoCredentialsError:
        print("Credentials not available")
    except Exception as e:
        print(f"An error occurred: {e}")

# Example usage
bucket = 'im-kan-kan'
key = 'hardyhar'
data = 'Hello, World!'

app = FastAPI()

@app.get("/")
def root():
    return "wow, ok."

@app.get("/s3")
async def s3():
    return await s3_put_get_presign(bucket, key, data)
