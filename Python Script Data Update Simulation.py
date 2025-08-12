import pandas as pd
from datetime import datetime
from google.cloud import storage
import functions_framework

BUCKET_NAME = 'datajob4d4m4st1t1'
SOURCE_FILE_PATH = 'Online_Retail.csv'

storage_client = storage.Client()

@functions_framework.cloud_event
def simulate_daily_update(cloud_event):
    print("Cloud Function triggered. Appending to existing CSV...")

    try:
        # 1. Download old csv file from Google Cloud bucket
        bucket = storage_client.bucket(BUCKET_NAME)
        blob = bucket.blob(SOURCE_FILE_PATH)
        
        existing_data = pd.read_csv(blob.open("r"))
        print(f"Existing data rows: {len(existing_data)}")

        # 2. Generate new data from sample of old data
        sample_size = pd.Series(range(5, 16)).sample(1).iloc[0]
        new_batch = existing_data.sample(n=sample_size)
        print(f"New batch rows: {len(new_batch)}")

        # 3. Append new data with old data
        updated_data = pd.concat([existing_data, new_batch], ignore_index=True)

        # 4. Overwrite old data in google cloud bucket
        blob = bucket.blob(SOURCE_FILE_PATH)
        blob.upload_from_string(updated_data.to_csv(index=False), content_type='text/csv')

        print(f"Updated CSV saved with {len(updated_data)} rows.")
        return 'OK', 200

    except Exception as e:
        print(f"Error: {e}")
        return 'Error processing file.', 500
