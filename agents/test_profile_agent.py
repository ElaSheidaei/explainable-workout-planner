from profile_agent import ProfileAgent


agent = ProfileAgent()

text = [
    """
    I am a beginner and I want to lose weight.
    I train at home three times a week for 30 minutes.
    I don't want jumping exercises and I have no equipment.
    """,

    """
    I am intermediate and I want to get stronger.
    I can train four times a week for one hour.
    """
]

for t in text:
    result = agent.process(t)
    
    print("\nPROFILE:")
    print(result["profile"])
    
    print("\nMISSING FIELDS:")  
    print(result["missing_fields"])
    
    print("\nCOMPLETE:")
    print(result["complete"])