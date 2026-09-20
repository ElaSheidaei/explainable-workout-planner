import re


def extract_goal(text):
    
    text = text.lower()
    
    goal_keywords = {
        "strength": [
            "strength",
            "get stronger",
            "become stronger",
            "muscle gain",
            "build muscle",
            "increase strength",
            "build strength",
        ],
        
        "fat_loss": [
            "lose fat",
            "fat loss",
            "lose weight",
            "weight loss",
            "burn fat"
        ],
        
        "endurance": [
            "endurance",
            "improve endurance",
            "stamina",
            "stability",
            "increase stamina",
        ],

        "general_fitness": [
            "general fitness",
            "get fit",
            "stay fit",
            "keep fit",
            "general training"
        ],
    }
    
    for goal, keywords in goal_keywords.items():
        for keyword in keywords:
            if keyword in text:
                return goal
            
    
    return None

  
def extract_level(text):
    
    text = text.lower()
    
    level_keywords = {
        "beginner": [
            "beginner",
            "new to training",
            "just starting",
            "just started",
            "no experience",
        ],

        "intermediate": [
            "intermediate",
            "some experience",
            "experienced",
            "training for a while",
        ],
    }

    for level, keywords in level_keywords.items():
        for keyword in keywords:
            if keyword in text:
                return level

    return None


def extract_sessions_per_week(text):
    text = text.lower()

    # Convert the written numbers used in our domain
    # to digits before applying the patterns.
    number_words = {
        "two": "2",
        "three": "3",
        "four": "4",
    }

    for word, digit in number_words.items():
        text = re.sub(rf"\b{word}\b", digit, text)

    patterns = [
        r"(\d)\s*times?\s*(?:a|per)\s*week",
        r"(\d)\s*sessions?\s*(?:a|per)\s*week",
        r"train\s*(\d)\s*times?\s*(?:a|per)\s*week",
    ]

    for pattern in patterns:
        match = re.search(pattern, text)

        if match:
            sessions = int(match.group(1))

            if sessions in [2, 3, 4]:
                return sessions

    return None


def extract_duration(text):
    text = text.lower()

    # Common expressions written with words.
    if "half an hour" in text or "half hour" in text:
        return 30

    if "one hour" in text or "an hour" in text:
        return 60

    # Duration written in minutes.
    minute_patterns = [
        r"(\d+)\s*minutes?",
        r"(\d+)\s*mins?",
        r"(\d+)\s*min\b",
    ]

    for pattern in minute_patterns:
        match = re.search(pattern, text)

        if match:
            return int(match.group(1))

    # Duration written in hours.
    hour_pattern = r"(\d+)\s*hours?"

    match = re.search(hour_pattern, text)

    if match:
        hours = int(match.group(1))
        return hours * 60

    return None



def extract_location(text):
    text = text.lower()

    if "at home" in text or "home workout" in text:
        return "home"

    if "at the gym" in text or "in the gym" in text:
        return "gym"

    return None


def extract_equipment(text):
    text = text.lower()

    # Check explicit statements about having no equipment first.
    no_equipment_keywords = [
        "no equipment",
        "without equipment",
        "bodyweight only",
        "only bodyweight",
    ]

    for keyword in no_equipment_keywords:
        if keyword in text:
            return "none"

    # Dumbbells are the intermediate equipment option.
    if "dumbbell" in text or "dumbbells" in text:
        return "dumbbells"

    # If the user explicitly says that gym equipment is available.
    gym_equipment_keywords = [
        "gym equipment",
        "full gym",
        "all gym equipment",
    ]

    for keyword in gym_equipment_keywords:
        if keyword in text:
            return "gym"

    return None


def extract_constraints(text):
    text = text.lower()

    constraints = []

    high_impact_keywords = [
        "no jumping",
        "avoid jumping",
        "without jumping",
        "don't want jumping",
        "don't want any jumping",
        "do not want jumping",
        "do not want any jumping",
        "no high impact",
        "avoid high impact",
        "low impact",
    ]

    running_keywords = [
        "no running",
        "avoid running",
        "without running",
        "don't want to run",
        "do not want to run",
    ]

    floor_keywords = [
        "no floor exercises",
        "avoid floor exercises",
        "without floor exercises",
        "nothing on the floor",
        "can't do floor exercises",
        "cannot do floor exercises",
    ]

    short_session_keywords = [
        "short session",
        "short sessions",
        "quick workout",
        "quick workouts",
    ]

    for keyword in high_impact_keywords:
        if keyword in text:
            constraints.append("no_high_impact")
            break

    for keyword in running_keywords:
        if keyword in text:
            constraints.append("no_running")
            break

    for keyword in floor_keywords:
        if keyword in text:
            constraints.append("no_floor_exercises")
            break

    for keyword in short_session_keywords:
        if keyword in text:
            constraints.append("short_session")
            break

    return constraints


def extract_profile(text):
    goal = extract_goal(text)
    level = extract_level(text)
    sessions = extract_sessions_per_week(text)
    duration = extract_duration(text)
    location = extract_location(text)
    equipment = extract_equipment(text)
    constraints = extract_constraints(text)
    
    defaults_used = []

    # Use 3 weekly sessions if the user did not specify frequency.
    if sessions is None:
        sessions = 3
        defaults_used.append("sessions_per_week")

    # Use 45 minutes if the user did not specify session duration.
    if duration is None:
        duration = 45
        defaults_used.append("duration")

    # If equipment is not specified, infer it from the location.
    if equipment is None:
        if location == "gym":
            equipment = "gym"
            defaults_used.append("equipment")
        elif location == "home":
            equipment = "none"
            defaults_used.append("equipment")

    return {
        "goal": goal,
        "level": level,
        "sessions_per_week": sessions,
        "duration": duration,
        "location": location,
        "equipment": equipment,
        "constraints": constraints,
        "defaults_used": defaults_used,
    }    
    




if __name__ == "__main__":
    tests = [
        "I am a beginner and I want to lose weight. I can train 3 times a week.",
        "I am intermediate and want to get stronger. I can train 4 times per week.",
        "I am new to training and want to stay fit. I have 2 sessions a week.",
        "I have some experience and want to improve endurance. I train 3 times a week.",
    ]
    
    
    for text in tests:
        print(text)
        print("Goal:", extract_goal(text))
        print("Level:", extract_level(text))
        print("Sessions:", extract_sessions_per_week(text))
        print()
        
        
    tests = [
    "I can train for 30 minutes",
    "I have 45 min for each session",
    "I can train for one hour",
    "I have 1 hour available",
    "I have an hour for my workout",
    "I can exercise for half an hour",
    "I want to train at home",
    ]

    for text in tests:
        print(text, "->", extract_duration(text))
        
        
    
    tests = [
    "I train at home with no equipment",
    "I train at home with dumbbells",
    "I train at the gym",
    "I have access to a full gym",
    "I prefer bodyweight only",
    ]

    for text in tests:
        print(text)
        print("Location:", extract_location(text))
        print("Equipment:", extract_equipment(text))
        print()
        
        
    tests = [
    "I don't want any jumping exercises",
    "I want a low impact workout with no running",
    "I cannot do floor exercises",
    "I need short sessions",
    "I want no jumping, no running and no floor exercises",
    "I have no particular constraints",
    ]

    for text in tests:
        print(text)
        print("Constraints:", extract_constraints(text))
        print()
        
    
    text = """
    I am an intermediate user and I want to get stronger.
    I train at the gym for one hour.
    I don't want any jumping exercises.
    """

    print(extract_profile(text))
    
    text = """
    I am a beginner and I want to lose weight.
    I can train at home two times a week for 30 minutes.
    I don't want jumping exercises and I have no equipment.
    """

    print(extract_profile(text))
    
    print(extract_profile(
    "I am intermediate and want to get stronger. "
    "I train at the gym four times a week for one hour."
    ))
    
    text = """
    I am an intermediate user and I want to get stronger.
    I train at the gym.
    """

    print(extract_profile(text))