import sys
from pathlib import Path


# Add the project root to the Python path so that
# the NLP module can be imported from the agents folder.
project_dir = Path(__file__).resolve().parent.parent
sys.path.append(str(project_dir))

from nlp.extractor import extract_profile


class ProfileAgent:
    
    def process(self, text):
        profile = extract_profile(text)

        missing_fields = []
        
        # These fields need to be explicitly provided by the user.
        required_fields = ["goal", "level", "location"]
        
        for field in required_fields:
            if profile[field] is None:
                missing_fields.append(field)
                
        
        return{
            "profile": profile,
            "missing_fields": missing_fields,
            "complete": len(missing_fields) == 0
        }
        
        
#Is the resulting profile ready to send to the planner?

# ProfileAgent
#     │
#     ├── complete → PlannerAgent
#     │
#     └── incomplete → stop and report missing information