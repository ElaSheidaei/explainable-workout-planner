# Explainable Workout Planner

## Requirements and Installation

The project requires:

- Python 3
- SWI-Prolog
- Streamlit
- PySwip

First, install [SWI-Prolog](https://www.swi-prolog.org/) and make sure it is available on your system.

Install the required Python packages with:

```bash
pip install streamlit pyswip
```

## Running the Application

Open a terminal in the project directory and run:

```bash
streamlit run ui.py
```

Streamlit will start the application locally and provide a URL that can be opened in a web browser.

## How to Use

Enter a short natural-language description of your training preferences in the text area. The input can specify:

- training goal: strength, general fitness, fat loss, or endurance
- level: beginner or intermediate
- weekly frequency: 2, 3, or 4 sessions
- session duration
- location: home or gym
- equipment: none, dumbbells, or gym equipment
- optional constraints: no high-impact exercises, no running, no floor exercises, or short session

Example:

> I am an intermediate user and I want to build strength. I can train two times per week for 45 minutes at the gym and I don't want any jumping exercises.

Select **Generate Workout Plan**. The application will display:

1. the profile extracted from the input;
2. the generated weekly workout plan;
3. an explanation of the main planning decisions and applied constraints.

## Project Structure

```text
FinalProject/
├── agents/
│   ├── profile_agent.py
│   ├── planner_agent.py
│   ├── constraint_agent.py
│   ├── explanation_agent.py
│   ├── prolog_interface.py
│   ├── test_profile_agent.py
│   ├── test_planner_agent.py
│   ├── test_constraint_agent.py
│   ├── test_explanation_agent.py
│   ├── test_prolog_connection.py
│   └── test_pipeline.py
│
├── nlp/
│   └── extractor.py
│
├── Prolog/
│   ├── exercises.pl
│   ├── compatibility_rules.pl
│   ├── workout_rules.pl
│   ├── training_schemes.pl
│   └── explanation_rules.pl
│
├── app.py
├── ui.py
└── test_final_system.py
```

### Python Components

- **`ui.py`** – implements the Streamlit user interface.
- **`app.py`** – contains the main `WorkoutPlanner` controller and connects the different stages of the application.
- **`nlp/extractor.py`** – extracts the structured user profile from natural-language input using rule-based matching.

### Agents

- **`profile_agent.py`** – extracts and validates the user profile.
- **`planner_agent.py`** – sends the structured profile to Prolog and processes the generated plan and reasoning information.
- **`constraint_agent.py`** – independently validates the selected exercises against the active constraints.
- **`explanation_agent.py`** – converts the symbolic reasoning information into readable explanations.
- **`prolog_interface.py`** – manages communication between Python and SWI-Prolog through PySwip.

### Prolog Knowledge Base

- **`exercises.pl`** – defines the exercises and their properties.
- **`compatibility_rules.pl`** – defines level, location, equipment, and constraint compatibility.
- **`workout_rules.pl`** – defines weekly structures, session construction, exercise selection, and plan generation.
- **`training_schemes.pl`** – defines goal- and level-dependent exercise prescriptions.
- **`explanation_rules.pl`** – collects the symbolic planning reasons and constraint effects used for explanations.

### Tests

The `test_*.py` files contain tests for the individual components and their integration. The complete system can be tested with:

```bash
python test_final_system.py
```