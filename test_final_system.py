from app import WorkoutPlanner

planner = WorkoutPlanner()


test_cases = [
    {
        "name": "Strength + explicit constraint",
        "text": """
        I am an intermediate user and I want to get stronger.
        I train at the gym two times a week for 45 minutes.
        I don't want any jumping exercises.
        """
    },

    {
        "name": "Beginner + defaults",
        "text": """
        I am a beginner and I want general fitness.
        I train at home.
        """
    },

    {
        "name": "Fat loss + multiple constraints",
        "text": """
        I am a beginner and I want to lose weight.
        I train at the gym three times a week for 30 minutes.
        I want no running and no floor exercises.
        """
    },

    {
        "name": "Endurance",
        "text": """
        I am an intermediate user and I want to improve my endurance.
        I train at the gym four times a week for 45 minutes.
        """
    },

    {
        "name": "Incomplete profile",
        "text": """
        I am a beginner and I want to get stronger.
        I train three times a week for 45 minutes.
        """
    },

    {
        "name": "Known unsupported combination",
        "text": """
        I am an intermediate user and I want to get stronger.
        I train at home three times a week for 45 minutes
        with no equipment.
        """
    }
]

for test in test_cases:

    print("\n" + "=" * 70)
    print(test["name"])
    print("=" * 70)

    result = planner.process_request(test["text"])

    print("Success:", result["success"])

    if result["success"]:
        print("Profile:", result["profile"])

        for day in result["week"]:
            print(
                f"Day {day['day']} - {day['session']}:",
                [exercise["exercise"] for exercise in day["exercises"]]
            )

        print("Explanation:")
        for explanation in result["explanation"]:
            print("-", explanation)

    else:
        print("Stage:", result["stage"])
        print("Message:", result["message"])

        if "missing_fields" in result:
            print("Missing fields:", result["missing_fields"])

        if "violations" in result:
            print("Violations:", result["violations"])