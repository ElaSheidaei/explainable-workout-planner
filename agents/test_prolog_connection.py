from prolog_interface import PrologInterface


profile = {
    "goal": "strength",
    "level": "intermediate",
    "sessions_per_week": 2,
    "duration": 45,
    "location": "gym",
    "equipment": "gym",
    "constraints": ["no_high_impact"],
}


prolog = PrologInterface()

result = prolog.build_plan(profile)

if result is None:
    print("No valid workout plan could be generated for this profile.")
else:
    print("Week:")
    print(result["Week"])

    print("\nExplanation:")
    print(result["Explanation"])

    print("\nConstraint effects:")
    print(result["ConstraintEffects"])
    
    
    
print(
    prolog.violates_constraint(
        "jump_squat",
        "no_high_impact"
    )
)

print(
    prolog.violates_constraint(
        "push_up",
        "no_high_impact"
    )
)