from email import message_from_bytes
from typing import Dict
from xmlrpc import client
from lxml import etree
import json
import os
import google.generativeai as genai

AI_CONFIG_PATH = os.path.join(os.path.dirname(__file__), 'ai_config.json')

def prepare_envelope(envelope) -> Dict:
    email_data = {}
    email_data['raw_email'] = envelope.content.decode('unicode_escape', errors='replace')
    email_data['raw_body'] = parse_email_body(envelope)
    email_data['etree'] = etree.fromstring(email_data['raw_body'], parser=etree.HTMLParser())
    email_data['text'] = etree.tostring(email_data['etree'], method='text', encoding='unicode')
    return email_data

def parse_email_body(envelope) -> str:
    msg = message_from_bytes(envelope.content)
    return msg.get_payload(decode=True).decode('utf-8', errors='replace')

async def perform_ai_request(prompt: str) -> str:
    if not hasattr(perform_ai_request, "was_called"):
        ai_config = load_ai_config()
        genai.configure(api_key=ai_config['apiKey'])
        perform_ai_request.model = genai.GenerativeModel(ai_config['modelName'])
        perform_ai_request.was_called = True
    
    response = await perform_ai_request.model.generate_content_async(prompt)
    return response.text
        
def load_ai_config() -> Dict:
    with open(AI_CONFIG_PATH, 'r') as f:
        return json.load(f)