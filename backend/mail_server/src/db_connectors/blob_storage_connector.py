import uuid

from azure.storage.blob import BlobServiceClient
from src.app_settings import app_settings


class BlobStorageConnector:
    def __init__(self):
        self.blob_service_client = BlobServiceClient.from_connection_string(
            app_settings.AZURE_STORAGE_CONNECTION_STRING.get_secret_value()
        )
        self.container_name = app_settings.AZURE_BLOB_CONTAINER_NAME

    async def save_email_blobs(self, raw_email, body):
        unique_id = str(uuid.uuid4())
        raw_email_url = self.save_blob(blob_name=f"raw_emails/{unique_id}_raw.eml", data=raw_email.encode("utf-8"))
        body_url = self.save_blob(blob_name=f"email_bodies/{unique_id}_body.txt", data=body.encode("utf-8"))
        return raw_email_url, body_url

    def save_blob(self, blob_name: str, data: bytes) -> str:
        blob_client = self.blob_service_client.get_blob_client(container=self.container_name, blob=blob_name)
        blob_client.upload_blob(data, overwrite=True)
        blob_url = blob_client.url
        return blob_url


blob_storage = BlobStorageConnector()
