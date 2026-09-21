import re
from prolog_interface import PrologInterface

class PlannerAgent: 
    
    def __init__(self):
        self.prolog = PrologInterface()
        
        
    def format_exercise(self, plan):
        """Convert one Prolog prescription term into a UI-friendly dictionary."""
        
        
        # PySwip terms are converted to text here because the three output functors
        # have fixed, controlled formats and are straightforward to parse.
        plan = str(plan)

        # Standard repetition-based exercise
        match = re.match(
            r"exercise_plan\(([^,]+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\)",
            plan
        )

        if match:
            return {
                "exercise": match.group(1).replace("_", " ").title(),
                "type": "repetition",
                "sets": int(match.group(2)),
                "reps": int(match.group(3)),
                "rest_min": int(match.group(4)),
                "rest_max": int(match.group(5))
            }

        # Time-based exercise
        match = re.match(
            r"timed_plan\(([^,]+),\s*(\d+),\s*(\d+),\s*(\d+),\s*(\d+)\)",
            plan
        )

        if match:
            return {
                "exercise": match.group(1).replace("_", " ").title(),
                "type": "timed",
                "sets": int(match.group(2)),
                "seconds": int(match.group(3)),
                "rest_min": int(match.group(4)),
                "rest_max": int(match.group(5))
            }

        # Cardio exercise
        match = re.match(
            r"cardio_plan\(([^,]+),\s*(\d+)\)",
            plan
        )

        if match:
            return {
                "exercise": match.group(1).replace("_", " ").title(),
                "type": "cardio",
                "minutes": int(match.group(2))
            }

        return None
    
    def format_week(self, week):
        """Translate the symbolic Prolog week into the representation shown by the UI."""
        formatted_week = []
        
        for day in week:
            day_text = str(day)
            
            
            # A Prolog day has the form day(Number, SessionType, ExercisePlans).
            # The symbolic session type is kept, but made readable for display.
            day_match = re.match(
                r"day\((\d+),\s*([^,]+),",
                day_text
            )
            
            if not day_match:
                continue
            
            day_number = int(day_match.group(1))
            session_type = day_match.group(2).strip()
            
            # Extract all exercise prescriptions from the day.
            exercise_strings = re.findall(
                r"(exercise_plan\([^)]+\)|timed_plan\([^)]+\)|cardio_plan\([^)]+\))",
                day_text
            )

            exercises = []

            for exercise_string in exercise_strings:
                formatted_exercise = self.format_exercise(exercise_string)

                if formatted_exercise is not None:
                    exercises.append(formatted_exercise)

            formatted_week.append({
                "day": day_number,
                "session": session_type.replace("_", " ").title(),
                "exercises": exercises
            })

        return formatted_week
    

    def process(self, profile):
        """Request a plan and package both its display and reasoning representations."""
        result = self.prolog.build_plan(profile)
        
        if result is None:
            return{
                "success": False,
                "week": None,
                "formatted_week": None,
                "reasoning": None,
                "constraint_effects": None,
                "message": "No valid workout plan could be generated for this profile."
            }
            
        formatted_week = self.format_week(result["Week"])
        return {
            "success": True,
            "week": result["Week"],
            "formatted_week": formatted_week,
            "reasoning": result["Explanation"],
            "constraint_effects": result["ConstraintEffects"],
            "message": "Workout plan generated successfully."
        }
        
        