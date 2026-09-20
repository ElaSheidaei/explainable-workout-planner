from pathlib import Path
from pyswip import Prolog


class PrologInterface:

    def __init__(self):
        self.prolog = Prolog()

        project_dir = Path(__file__).resolve().parent.parent
        prolog_file = project_dir / "prolog" / "explanation_rules.pl"

        # Escape the apostrophe contained in the project path.
        prolog_path = str(prolog_file).replace("\\", "/")
        prolog_path = prolog_path.replace("'", "''")

        list(self.prolog.query(f"consult('{prolog_path}')"))

    def _prolog_list(self, items):
        return "[" + ",".join(items) + "]"
    
    

    def build_plan(self, profile):
        constraints = self._prolog_list(profile["constraints"])

        query = f"""
        build_explainable_plan(
            {profile['goal']},
            {profile['sessions_per_week']},
            {profile['level']},
            {profile['duration']},
            {profile['location']},
            {profile['equipment']},
            {constraints},
            Week,
            Explanation,
            ConstraintEffects
        )
        """

        results = list(self.prolog.query(query, maxresult=1))

        if not results:
            return None

        return results[0]
    
    def violates_constraint(self, exercise, constraint):
        query = f"violates_constraint({exercise}, {constraint})"

        results = list(self.prolog.query(query, maxresult=1))

        return len(results) > 0

    
    
    