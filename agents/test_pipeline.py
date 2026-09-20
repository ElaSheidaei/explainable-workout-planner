from profile_agent import ProfileAgent
from planner_agent import PlannerAgent
from constraint_agent import ConstraintAgent

profile_agent = ProfileAgent()
planner_agent = PlannerAgent()
constraint_agent = ConstraintAgent()


text = """
I am an intermediate user and I want to get stronger.
I train at the gym two times a week for 45 minutes.
I don't want any jumping exercises.
"""

# Profile Agent
# Step 1: extract and check the profile.
profile_result = profile_agent.process(text)

print("USER INPUT:")
print(text)

print("\nPROFILE AGENT:")
print(profile_result)

# Continue only if the profile is complete.
if profile_result["complete"]:

    profile = profile_result["profile"]
    


    # Planner Agent
    # Step 2: only send a complete profile to the planner.
    planner_result = planner_agent.process(profile)

    print("\nPLANNER AGENT:")
    print("Success:", planner_result["success"])
    print("Message:", planner_result["message"])
        
    if planner_result["success"]:
        
        print("\nWEEK:")
        print(planner_result["week"])
        
        # Constraint Agent
        # Step 3: check the plan against the user's constraints.
        constraint_result = constraint_agent.process(
            planner_result["week"],
            profile["constraints"]
        )

        print("\nCONSTRAINT AGENT:")
        print("Valid:", constraint_result["valid"])
        print(
            "Exercises checked:",
            constraint_result["exercises_checked"]
        )
        print(
            "Violations:",
            constraint_result["violations"]
        )
    else:
        print("\nPlanning stopped because no valid plan was found.")

        
else:
    print("\n The profile is incomplete")
    print("Missing fields:", profile_result["missing_fields"])
    
    
    