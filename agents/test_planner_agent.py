from planner_agent import PlannerAgent


planner = PlannerAgent()

profile = {
    "goal": "strength",
    "level": "intermediate",
    "sessions_per_week": 2,
    "duration": 45,
    "location": "gym",
    "equipment": "gym",
    "constraints": ["no_high_impact"],
    "defaults_used": []
}

result = planner.process(profile)

print("Success:", result["success"])

if result["success"]:
    print("\nFORMATED WEEK:")
    
    for day in result["formatted_week"]:
        print(f"\nDay {day['day']} - {day['session']}")
        
        for exercise in day["exercises"]:
            print(exercise)
            
else:
    print(result["message"])

# result = agent.process(profile)

# print("SUCCESS:")
# print(result["success"])

# print("\nMESSAGE:")
# print(result["message"])

# print("\nWEEK:")
# print(result["week"])

# print("\nREASONING:")
# print(result["reasoning"])

# print("\nCONSTRAINT EFFECTS:")
# print(result["constraint_effects"])


# planner = PlannerAgent()

# print(
#     planner.format_exercise(
#         "exercise_plan(push_up, 4, 5, 120, 180)"
#     )
# )

# print(
#     planner.format_exercise(
#         "timed_plan(plank, 4, 30, 120, 180)"
#     )
# )

# print(
#     planner.format_exercise(
#         "cardio_plan(brisk_walking, 10)"
#     )
# )

