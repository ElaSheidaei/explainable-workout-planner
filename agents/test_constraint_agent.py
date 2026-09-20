from constraint_agent import ConstraintAgent


agent = ConstraintAgent()


week = [
    "day(1, full_body, "
    "['exercise_plan(jump_squat, 4, 5, 120, 180)', "
    "'exercise_plan(single_leg_rdl, 4, 5, 120, 180)', "
    "'exercise_plan(pike_push_up, 4, 5, 120, 180)', "
    "'exercise_plan(pull_up, 4, 5, 120, 180)', "
    "'timed_plan(plank, 4, 30, 120, 180)'])"
]

constraints = ["no_high_impact"]


result = agent.process(week, constraints)

print("Exercises checked:")
print(result["exercises_checked"])

print("\nValid:")
print(result["valid"])

print("\nViolations:")
print(result["violations"])