import pandas as pd
import streamlit as st

from app import WorkoutPlanner


st.set_page_config(
    page_title="Explainable Workout Planner",
    page_icon="🏋️",
    layout="wide"
)


# -------------------------
# Application
# -------------------------

planner = WorkoutPlanner()


# -------------------------
# Title
# -------------------------

st.title("Explainable Workout Planner")

st.write(
    "Describe your training goal and preferences in natural language. "
    "The system will generate a weekly workout plan and explain "
    "the reasoning behind it."
)


with st.expander("How should I describe my preferences?"):
    st.write(
        "The planner understands a controlled set of training preferences. "
        "For the best result, describe your:"
    )

    st.markdown(
        """
        - **Goal:** strength, general fitness, fat loss, or endurance
        - **Level:** beginner or intermediate
        - **Weekly frequency:** 2, 3, or 4 sessions per week
        - **Session duration:** for example, 30, 45, or 60 minutes
        - **Location:** home or gym
        - **Equipment:** no equipment, dumbbells, or gym equipment
        - **Optional constraints:** no high-impact exercises, no running, 
          no floor exercises, or a short session
        """
    )

# -------------------------
# User input
# -------------------------

user_text = st.text_area(
    "Describe your training preferences:",
    placeholder=(
        "Example: I am an intermediate user and I want to get stronger. "
        "I train at the gym two times a week for 45 minutes. "
        "I don't want any jumping exercises."
    ),
    height=140
)


# -------------------------
# Generate plan
# -------------------------

if st.button("Generate Workout Plan", type="primary"):

    if not user_text.strip():
        st.warning("Please describe your training preferences.")

    else:
        result = planner.process_request(user_text)

        # -------------------------
        # Error handling
        # -------------------------

        if not result["success"]:

            if result["stage"] == "profile":
                missing = ", ".join(
                    field.replace("_", " ")
                    for field in result["missing_fields"]
                )

                st.error(
                    f"The profile is incomplete. "
                    f"Please specify: {missing}."
                )

            elif result["stage"] == "planning":
                st.error(
                    "No valid workout plan could be generated for "
                    "this combination of preferences and constraints."
                )

            elif result["stage"] == "validation":
                st.error(
                    "The generated workout did not pass "
                    "constraint validation."
                )

        # -------------------------
        # Successful result
        # -------------------------

        else:
            profile = result["profile"]

            st.success("Workout plan generated successfully.")

            # -------------------------
            # Profile
            # -------------------------

            st.header("Your Profile")

            col1, col2, col3 = st.columns(3)

            with col1:
                st.write(
                    "**Goal:**",
                    profile["goal"].replace("_", " ").title()
                )
                st.write(
                    "**Level:**",
                    profile["level"].replace("_", " ").title()
                )

            with col2:
                st.write(
                    "**Sessions per week:**",
                    profile["sessions_per_week"]
                )
                st.write(
                    "**Duration:**",
                    f"{profile['duration']} minutes"
                )

            with col3:
                st.write(
                    "**Location:**",
                    profile["location"].replace("_", " ").title()
                )
                st.write(
                    "**Equipment:**",
                    profile["equipment"].replace("_", " ").title()
                )

            if profile["constraints"]:
                constraints = ", ".join(
                    constraint.replace("_", " ").title()
                    for constraint in profile["constraints"]
                )

                st.write("**Constraints:**", constraints)
            else:
                st.write("**Constraints:** None")

            # -------------------------
            # Weekly plan
            # -------------------------

            st.header("Your Weekly Plan")

            for day in result["week"]:

                st.subheader(
                    f"Day {day['day']} — {day['session']}"
                )

                rows = []

                for exercise in day["exercises"]:

                    if exercise["type"] == "repetition":
                        prescription = (
                            f"{exercise['reps']} reps"
                        )
                        sets = exercise["sets"]
                        rest = (
                            f"{exercise['rest_min']}–"
                            f"{exercise['rest_max']} s"
                        )

                    elif exercise["type"] == "timed":
                        prescription = (
                            f"{exercise['seconds']} s"
                        )
                        sets = exercise["sets"]
                        rest = (
                            f"{exercise['rest_min']}–"
                            f"{exercise['rest_max']} s"
                        )

                    elif exercise["type"] == "cardio":
                        prescription = (
                            f"{exercise['minutes']} min"
                        )
                        sets = "—"
                        rest = "—"

                    rows.append({
                        "Exercise": exercise["exercise"],
                        "Sets": sets,
                        "Reps / Duration": prescription,
                        "Rest": rest
                    })

                df = pd.DataFrame(rows)

                st.dataframe(
                    df,
                    use_container_width=True,
                    hide_index=True
                )
                
                
        

            # -------------------------
            # Explanation
            # -------------------------

            st.header("Why This Plan?")

            for explanation in result["explanation"]:
                st.write(f"• {explanation}")
                
                
                
                  
            st.info(
                "**Choosing the training weight:** The planner recommends exercises, "
                "sets, repetitions, and rest intervals, but it does not prescribe the "
                "weight to use. Choose a resistance appropriate to your current ability "
                "and training level while maintaining proper exercise technique.\n\n"
                "**1RM (one-repetition maximum)** is the maximum load that a person can "
                "lift for one complete repetition of an exercise. Training loads are often "
                "described as a percentage of 1RM. However, directly testing a true 1RM "
                "may not be appropriate for everyone, particularly inexperienced users, "
                "so the planner does not calculate or prescribe an individual 1RM."
            )
            
            st.warning(
                "**Important:** This application is an educational prototype developed "
                "to demonstrate symbolic reasoning and an agent-oriented planning "
                "architecture. The generated workouts are not medically validated and "
                "should not be considered medical or professional training advice. "
                "Individual health conditions, injuries, rehabilitation needs, and other "
                "medical factors are outside the scope of the system."
            )
            