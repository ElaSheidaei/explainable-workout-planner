from pathlib import Path
from pyswip import Prolog


class PrologInterface:
    """Create the Prolog engine and load all the file from knowledge-base"""
    def __init__(self):
        self.prolog = Prolog()

        project_dir = Path(__file__).resolve().parent.parent
        # explanation_rules.pl consults workout_rules.pl, which consults
        #all the other files. 
        prolog_file = project_dir / "prolog" / "explanation_rules.pl"

        # Escape the apostrophe contained in the project path.
        prolog_path = str(prolog_file).replace("\\", "/")
        prolog_path = prolog_path.replace("'", "''")

        list(self.prolog.query(f"consult('{prolog_path}')"))

    def _prolog_list(self, items):
        """Serialize the controlled list of atom strings as a Prolog list, e.g. [no_running]."""
        return "[" + ",".join(items) + "]"
    
    

    def build_plan(self, profile):
        """run build_explainable_plan/10 and return its first valid solution"""
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
        # maxresult=1 takes the first valid solution 
        # one extension then could be ranking the alternatives and select between them.
        results = list(self.prolog.query(query, maxresult=1))

        if not results:
            return None

        return results[0]
    
    def violates_constraint(self, exercise, constraint):
        """Ask Prolog whether one selected exercise violates one user's constraint"""
        query = f"violates_constraint({exercise}, {constraint})"

        # Only exesitence matter here, so if there is one means the violation holds.
        results = list(self.prolog.query(query, maxresult=1))

        return len(results) > 0

    
    
    