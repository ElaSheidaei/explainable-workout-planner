import sys 
from pathlib import Path 


# Make the agents folder available for imports.
project_dir = Path(__file__).resolve().parent
agents_dir = project_dir / "agents"
sys.path.append(str(agents_dir))

from profile_agent import ProfileAgent
from planner_agent import PlannerAgent
from constraint_agent import ConstraintAgent
from explanation_agent import ExplanationAgent


class WorkoutPlanner:
    
    def __init__(self):
        self.profile_agent = ProfileAgent()
        self.planner_agent = PlannerAgent()
        self.constraint_agent = ConstraintAgent()
        self.explanation_agent = ExplanationAgent()
        
    
    def process_request(self, text):
        
        
        # Extract the structured user profile.
        profile_result = self.profile_agent.process(text)
        
        if not profile_result["complete"]:
            return{
                "success": False,
                "stage": "profile",
                "message": "The user profile is incomplete.",
                "missing_fields": profile_result["missing_fields"]
            }
            
        profile = profile_result["profile"]
        
        # Generate the workout through the symbolic planner
        planner_result = self.planner_agent.process(profile)
        
        if not planner_result["success"]:
            return {
                "success": False,
                "stage": "planning",
                "message": planner_result["message"],
                "profile": profile
            }
            
        
        # Validate the generated exercises
        constraint_result = self.constraint_agent.process(
            planner_result["week"],
            profile["constraints"]
        )
        
        if not constraint_result["valid"]:
            return {
                "success": False,
                "stage": "validation",
                "message": "The generated workout did not pass constraint validation.",
                "profile": profile,
                "violations": constraint_result["violations"]
            }
            
        
        # Generate the human-readable explanation
        explanation_result = self.explanation_agent.process(
            profile,
            planner_result,
            constraint_result
        )
        
        return{
            "success": True,
            "profile": profile,
            "week": planner_result["formatted_week"],
            "explanation": explanation_result["explanations"],
            "constraint_effects": explanation_result["constraint_effects"]
        }
        
        
        
# if __name__ == "__main__":

#     planner = WorkoutPlanner()

#     text = """
#     I am an intermediate user and I want to get stronger.
#     I train at the gym two times a week for 45 minutes.
#     I don't want any jumping exercises.
#     """

#     result = planner.process_request(text)

#     print("\nFINAL RESULT:")
#     print(result)