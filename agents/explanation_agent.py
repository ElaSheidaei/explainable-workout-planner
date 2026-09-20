import re


class ExplanationAgent:

    def extract_reasoning(self, reasoning):
        reasoning_text = str(reasoning)

        result = {
            "split": None,
            "exercise_count": None
        }

        # Example:
        # reason(split_selection, 2, intermediate, full_body)
        split_match = re.search(
            r"reason\(split_selection,\s*\d+,\s*\w+,\s*(\w+)\)",
            reasoning_text
        )

        if split_match:
            result["split"] = split_match.group(1)

        # Example:
        # reason(session_size, 45, 5)
        size_match = re.search(
            r"reason\(session_size,\s*\d+,\s*(\d+)\)",
            reasoning_text
        )

        if size_match:
            result["exercise_count"] = int(size_match.group(1))

        return result
    
    def extract_constraint_effects(self, constraint_effects):
        effects = {}

        for effect in constraint_effects:
            effect_text = str(effect)

            match = re.match(
                r"constraint_effect\(([^,]+),\s*\[(.*?)\]\)",
                effect_text
            )

            if not match:
                continue

            constraint = match.group(1).strip()
            exercises_text = match.group(2)

            exercises = re.findall(
                r"'?([a-zA-Z0-9_]+)'?",
                exercises_text
            )

            effects[constraint] = exercises

        return effects
    
    def process(self, profile, planner_result, constraint_result):
        reasoning = self.extract_reasoning(
            planner_result["reasoning"]
        )
        
        constraint_effects = self.extract_constraint_effects(
            planner_result["constraint_effects"]
        )
        
        explanations = []
        
        split = reasoning["split"]
        exercise_count = reasoning["exercise_count"]
        defaults_used = profile.get("defaults_used", [])

        
        # Explain weekly structure
        if split is not None:
            split_names = {
                "full_body": "full body",
                "upper_lower": "upper/lower",
                "push_pull_legs": "push/pull/legs"
            }

            split_name = split_names.get(
                reasoning["split"],
                reasoning["split"].replace("_", " ")
            )
            
            article = "An" if split_name[0].lower() in "aeiou" else "A"
            
            sentence = (
                f"{article} {split_name} structure was selected for "
                f"{profile['sessions_per_week']} training sessions per week "
                f"at {profile['level']} level."
            )
            
            if "sessions_per_week" in defaults_used:
                sentence += (
                    f" Since the user did not specify the weekly frequency, "
                    f"the default of {profile['sessions_per_week']} sessions "
                    f"per week was used."
                )
                
            explanations.append(sentence)
            
            
        # Explain session size
        if exercise_count is not None:
            sentence = (
                f"Each session contains {exercise_count} exercises "
                f"based on the session duration of {profile['duration']} minutes."
            )
            
            if "duration" in defaults_used:
                sentence += (
                    f" Since the user did not specify the session duration, "
                    f"the default of {profile['duration']} minutes was used."
                )
            
            explanations.append(sentence)



        # Explain goal and prescription 
        goal_text = profile["goal"].replace("_", " ")
        
        explanations.append(
            f"The exercise prescription was selected for the "
            f"{goal_text} goal and {profile['level']} training level."
        )
        
    
        
        # Explain location and equipment
        location_text = profile["location"].replace("_", " ")    
        equipment_text = profile["equipment"].replace("_", " ") 
        
        if "equipment" in defaults_used:
            if profile["location"] == "gym":
                explanations.append(
                    f"The selected training location is the {location_text}. "
                    f"Since the user did not specify the available equipment, "
                    f"full gym equipment was assumed."
                )
                
            elif profile["location"] == "home": 
                explanations.append(
                    f"The selected training location is {location_text}. "
                    f"Since the user did not specify the available equipment, "
                    f"no equipment was assumed."
                )
    
            else:
                explanations.append(
                    f"The plan uses exercises compatible with the selected "
                    f"{location_text} location and {equipment_text} equipment."
                )
        
        
        
        # Explain user constraints and validation
        if profile["constraints"]:
            for constraint in profile["constraints"]:
                constraint_text = constraint.replace("_", " ")

                excluded = constraint_effects.get(constraint, [])

                if excluded:
                    excluded_text = [
                        exercise.replace("_", " ").title()
                        for exercise in excluded
                    ]

                    explanations.append(
                        f"The {constraint_text} constraint was applied during "
                        f"planning. It excludes exercises such as "
                        f"{', '.join(excluded_text)}. "
                    )

                else:
                    explanations.append(
                        f"The {constraint_text} constraint was applied during "
                        f"planning."
                    )

            # ConstraintAgent validates the complete generated plan
            # against all user constraints.
            explanations.append(
                "The final workout was validated against all specified "
                "constraints, and none of the selected exercises violates them."
            )


        else:
            explanations.append(
                "No additional exercise constraints were specified."
            )
    

        return {
            "reasoning": reasoning,
            "constraint_effects": constraint_effects,
            "explanations": explanations,
            "text": " ".join(explanations)
        }