from email import message_from_bytes
from typing import Dict
from src.app_settings import app_settings
from lxml import etree
import google.generativeai as genai

def prepare_envelope(envelope) -> Dict:
    email_data = {}
    email_data['raw_email'] = envelope.content.decode('unicode_escape', errors='replace')
    create_email_body_and_subject(email_data, envelope)
    email_data['etree'] = etree.fromstring(email_data['raw_body'], parser=etree.HTMLParser())
    email_data['text'] = etree.tostring(email_data['etree'], method='text', encoding='unicode')
    return email_data

def create_email_body_and_subject(email_data, envelope) -> str:
    msg = message_from_bytes(envelope.content)
    email_data['subject'] = msg.get('Subject', 'No Subject')
    email_data['raw_body'] = msg.get_payload(decode=True).decode('utf-8', errors='replace')

async def perform_ai_request(prompt: str) -> str:
    if not hasattr(perform_ai_request, "was_called"):
        genai.configure(api_key=app_settings.AI_API_KEY)
        perform_ai_request.model = genai.GenerativeModel(app_settings.AI_MODEL_NAME)
        perform_ai_request.was_called = True
    
    response = await perform_ai_request.model.generate_content_async(prompt)
    return response.text