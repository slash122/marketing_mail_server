from src.jobs.base_job import EmailJob
from src.utils import perform_ai_request
import json
import re

class AiPersonalizationJob(EmailJob):
   async def run(self):
      prompt = AiPersonalizationJob.prompt_template.format(self.raw_email)
      prompt_response = await perform_ai_request(prompt)
      response_json = json.loads(self.clean_response(prompt_response))
      self.validate_response_json(response_json)
      return response_json
   
   def clean_response(self, response):
      return re.sub(r'\s|`|json', '', response.strip())

   def validate_response_json(self, response_json):
      required_keys = (
         "tech_stack",
         "subject_line",
         "textual_personalization",
         "visual_content",
         "personalization_modules",
         "campaign_tracking",
         "dynamic_asset_structuring",
         "total_score",
         "maturity_level"
      )
      for key in required_keys:
         if key not in response_json:
            raise ValueError(f"Missing key in response JSON: {key}")
        
    
   prompt_template = """
You are an email personalization analyst. Given the HTML code, UTMs, image URLs, personalization tags, and other metadata for a single email campaign, 
evaluate its personalization maturity using the following 7-point rubric (total = 30 points):

1. Technology Stack Personalization Capabilities (Json key: tech_stack)
   • Scale: 1–3 Weight: 6 
   1 = No visible ESP or personalization tech 
   2 = Recognizable mid-tier ESP (e.g. Klaviyo, Emarsys) 
   3 = Enterprise ESP or advanced provider visible (e.g. Salesforce Marketing Cloud, Movable Ink)
   
2. Subject Line Personalization (Json key: subject_line)
   • Scale: 1–3 Weight: 2 
   1 = Fully generic 
   2 = Simple token or name used 
   3 = Dynamic/contextual (location, past behavior, etc.)

3. Depth of Textual Personalization (Json key: textual_personalization)
   • Scale: 1–5 Weight: 6 
   1 = Fully generic 
   2 = Basic name or greeting 
   3 = Mentions preferences, segments or past purchases 
   4 = Multiple personalized copy elements 
   5 = Highly contextual (real-time, behavior-based)

4. Visual Content Personalization (Json key: visual_content)
   • Scale: 1–5 Weight: 6 
   1 = Generic banners 
   2 = Broad segment targeting (e.g. gender, season) 
   3 = Product recommendation blocks 
   4 = “Selected for you” visuals 
   5 = Dynamic real-time images (weather, stock levels, location) including Movable Ink

5. Use of Personalization Modules (Json key: personalization_modules)
   • Scale: 1–3 Weight: 5 
   1 = None observed 
   2 = Some dynamic widgets (countdowns, live clocks) 
   3 = Advanced personalization tech embedded (Movable Ink, Dynamic Yield, etc.)

6. Personalization Depth in Campaign Tracking (Json key: campaign_tracking)
   • Scale: 1–3 Weight: 4 
   1 = No or minimal UTMs
   2 = Standard five-parameter UTM (source, medium, campaign, content, term) 
   3 = Advanced segmentation tags (dynamic content IDs, AB-test tags, geo-specific values)

7. Dynamic Asset Structuring for Personalization (Json key: dynamic_asset_structuring)
   • Scale: 1–3 Weight: 1 
   1 = Static filenames (e.g. banner.jpg) 
   2 = Versioned/numbered (e.g. hero_v2.jpg, promo1.png) 
   3 = Highly structured/dynamic (hashed or user-specific IDs, folder paths per segment)

Maturity Levels (out of 30):
0–7   = Level 1 – No Personalization 
8–13  = Level 2 – Basic 
14–20 = Level 3 – Intermediate 
21–26 = Level 4 – Advanced 
27–30 = Level 5 – Best in Class

Instructions for Each Email Analysis: 
1. For each criterion, assign a raw score within its scale. 
2. Multiply each raw score by its weight → Weighted Points. 
3. Sum all weighted points for a Total Score (max 30). 
4. Map the Total Score to the corresponding Maturity Level. 
5. Present a table with columns: Criterion, Scale, Weight, Raw Score, Weighted Points. 
6. Conclude with: Total Score: X/30 → Level Y
and a 1–2-sentence rationale highlighting any unusually high or low ratings.

Instructions for Response Formatting:
1. Respond only in valid JSON format as follows: {{
  "tech_stack": {{"raw_score": int, "weighted_points": int}},
  "subject_line": {{"raw_score": int, "weighted_points": int}},
  "textual_personalization": {{"raw_score": int, "weighted_points": int}},
  "visual_content": {{"raw_score": int, "weighted_points": int}},
  "personalization_modules": {{"raw_score": int, "weighted_points": int}},
  "campaign_tracking": {{"raw_score": int, "weighted_points": int}},
  "dynamic_asset_structuring": {{"raw_score": int, "weighted_points": int}},
  "total_score": int,
  "maturity_level": int,
}}
2. Ensure all keys and values are present as specified.
Use the following email HTML content, UTMs, image URLs, personalization tags, and other metadata to perform your analysis: {}"""               