:- consult('workout_rules.pl').

% Explanation Rules
% -----------------
% These rules collect information about the decisions
% made by the planner. Python will later transform these
% reasons into simple sentences for the user.


% ----- Explain the selected weekly split -----

explain_split(
    SessionsPerWeek,
    Level,
    Split,
    reason(
        split_selection,
        SessionsPerWeek,
        Level,
        Split
    )
) :-
    split(
        SessionsPerWeek,
        Level,
        Split
    ).



% ----- Explain why an exercise is compatible -----

% Return the main properties that allowed an exercise
% to be used for a movement slot.

explain_exercise(
    Exercise,
    Slot,
    Level,
    Location,
    Equipment,
    Constraints,
    [
        reason(movement_match, Slot),
        reason(level_compatible, RequiredLevel),
        reason(location_compatible, Location),
        reason(equipment_compatible, RequiredEquipment),
        reason(constraints_satisfied, Constraints)
    ]
) :-
    candidate_for_slot(
        Exercise,
        Slot,
        Level,
        Location,
        Equipment,
        Constraints
    ),
    min_level(
        Exercise,
        RequiredLevel
    ),
    requires_equipment(
        Exercise,
        RequiredEquipment
    ).



% ----- Explain a goal preference -----

% This succeeds when the main role of an exercise
% is one of the preferred roles for the user's goal.

explain_goal_preference(
    Exercise,
    Goal,
    reason(
        goal_preference,
        Goal,
        Role
    )
) :-
    primary_role(
        Exercise,
        Role
    ),
    preferred_role(
        Goal,
        Role
    ).



% ----- Explain an exercise prescription -----

explain_prescription(
    Exercise,
    Goal,
    Level,
    Plan,
    reason(
        prescription,
        Goal,
        Level,
        Plan
    )
) :-
    prescribe_selected_exercise(
        Exercise,
        Goal,
        Level,
        Plan
    ).



% ----- Explain the general plan -----

% Collect the main information that influenced
% the construction of the weekly plan.

explain_plan(
    Goal,
    SessionsPerWeek,
    Level,
    Duration,
    Location,
    Equipment,
    Constraints,
    Explanation
) :-
    split(
        SessionsPerWeek,
        Level,
        Split
    ),

    session_exercise_count(
        Duration,
        Constraints,
        ExerciseCount
    ),

    Explanation = plan_explanation(
        reason(
            split_selection,
            SessionsPerWeek,
            Level,
            Split
        ),
        reason(
            session_size,
            Duration,
            ExerciseCount
        ),
        reason(
            goal,
            Goal
        ),
        reason(
            level_preference,
            Level
        ),
        reason(
            location,
            Location
        ),
        reason(
            equipment,
            Equipment
        ),
        reason(
            constraints,
            Constraints
        ),
        reason(
            prescription,
            Goal,
            Level
        )
    ).



% ----- Explain constraint effects -----

% Find the exercises that violate one constraint.

rejected_by_constraint(
    Constraint,
    RejectedExercises
) :-
    findall(
        Exercise,
        violates_constraint(
            Exercise,
            Constraint
        ),
        RejectedExercises
    ).


% Base case: there are no more constraints.

explain_constraints(
    [],
    []
).


% Check each constraint and save the exercises
% rejected because of it.

explain_constraints(
    [Constraint | RestConstraints],
    [
        constraint_effect(
            Constraint,
            RejectedExercises
        )
        | RestEffects
    ]
) :-
    rejected_by_constraint(
        Constraint,
        RejectedExercises
    ),

    explain_constraints(
        RestConstraints,
        RestEffects
    ).



% ----- Final explainable planner -----

% This is the main predicate that will be called from Python.
% It returns:
% - the concrete weekly plan
% - the general reasons behind the plan
% - the effects of the user's constraints

build_explainable_plan(
    Goal,
    SessionsPerWeek,
    Level,
    Duration,
    Location,
    Equipment,
    Constraints,
    Week,
    Explanation,
    ConstraintEffects
) :-
    % Build the concrete weekly workout plan.
    build_prescribed_week(
        Goal,
        SessionsPerWeek,
        Level,
        Duration,
        Location,
        Equipment,
        Constraints,
        Week
    ),

    % Explain the main reasoning behind the plan.
    explain_plan(
        Goal,
        SessionsPerWeek,
        Level,
        Duration,
        Location,
        Equipment,
        Constraints,
        Explanation
    ),

    % Explain which exercises were rejected
    % by the user's constraints.
    explain_constraints(
        Constraints,
        ConstraintEffects
    ).


