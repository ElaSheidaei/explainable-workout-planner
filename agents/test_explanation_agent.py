from profile_agent import ProfileAgent
from planner_agent import PlannerAgent
from constraint_agent import ConstraintAgent
from explanation_agent import ExplanationAgent


profile_agent = ProfileAgent()
planner_agent = PlannerAgent()
constraint_agent = ConstraintAgent()
explanation_agent = ExplanationAgent()


text = """
I am an intermediate user and I want to get stronger.
I train at the gym two times a week for 45 minutes.
I don't want any jumping exercises.
"""

# text = """
# I am a beginner and I want general fitness.
# I train at home.
# """

# Profile Agent
profile_result = profile_agent.process(text)

if not profile_result["complete"]:
    print("Incomplete profile:")
    print(profile_result["missing_fields"])
    exit()


profile = profile_result["profile"]


# Planner Agent
planner_result = planner_agent.process(profile)

if not planner_result["success"]:
    print(planner_result["message"])
    exit()


# Constraint Agent
constraint_result = constraint_agent.process(
    planner_result["week"],
    profile["constraints"]
)


# Explanation Agent
explanation_result = explanation_agent.process(
    profile,
    planner_result,
    constraint_result
)


print("PROFILE:")
print(profile)

print("\nEXTRACTED PROLOG REASONING:")
print(explanation_result["reasoning"])

print("\nEXPLANATION:")
for sentence in explanation_result["explanations"]:
    print("-", sentence)