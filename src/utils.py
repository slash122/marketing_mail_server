from src.app_settings import app_settings
import google.generativeai as genai

async def perform_ai_request(prompt: str) -> str:
    if not hasattr(perform_ai_request, "was_called"):
        genai.configure(api_key=app_settings.AI_API_KEY)
        perform_ai_request.model = genai.GenerativeModel(app_settings.AI_MODEL_NAME)
        perform_ai_request.was_called = True
    
    response = await perform_ai_request.model.generate_content_async(prompt)
    return response.text