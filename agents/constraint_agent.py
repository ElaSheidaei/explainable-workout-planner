import re

from prolog_interface import PrologInterface


class ConstraintAgent:

    def __init__(self):
        self.prolog = PrologInterface()

    def extract_exercises(self, week):
        """Extract exercise atoms from the three prescription term formats."""
        exercises = []

        for day in week:
            # Find exercise names inside the three possible plan formats.
            matches = re.findall(
                r"(?:exercise_plan|timed_plan|cardio_plan)\(([^,\s]+)",
                str(day)
            )

            exercises.extend(matches)

        return exercises

    def process(self, week, constraints):
        """Check every selected exercise against every active user constraint."""
        exercises = self.extract_exercises(week)
        violations = []

        for exercise in exercises:
            for constraint in constraints:
                if self.prolog.violates_constraint(exercise, constraint):
                    violations.append({
                        "exercise": exercise,
                        "constraint": constraint
                    })

        return {
            "valid": len(violations) == 0,
            "exercises_checked": exercises,
            "violations": violations
        }
        
