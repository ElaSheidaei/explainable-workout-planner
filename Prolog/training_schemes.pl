
% Goal-Based Training Schemes
%------------------------------
% These rules define how the selected exercises
% are prescribed according to goal and level.

% ---------- Goal-specific ranges ---------

% training_scheme(
%     Goal,
%     MinSets, MaxSets,
%     MinReps, MaxReps,
%     MinRest, MaxRest
% ).

training_scheme(
    strength,
    3, 5,     
    4, 6,      
    120, 180   
).

training_scheme(
    general_fitness,
    3, 4,
    8, 12,
    90, 150
).

training_scheme(
    fat_loss,
    3, 4,
    10, 15,
    90, 150
).

training_scheme(
    endurance,
    2, 3,
    12, 18,
    60, 120
).


% ----- Adapt the scheme to the user's level -----

% Beginners use the lower end of the sets and repetitions range.

target_scheme(
    Goal,
    beginner,
    Sets,
    Reps,
    RestMin,
    RestMax
) :-
    training_scheme(
        Goal,
        SetsMin,
        _SetsMax,
        RepsMin,
        _RepsMax,
        RestMin,
        RestMax
    ),
    Sets = SetsMin,
    Reps = RepsMin.


% Intermediate users use approximately the middle
% of the sets and repetitions range.

target_scheme(
    Goal,
    intermediate,
    Sets,
    Reps,
    RestMin,
    RestMax
) :-
    training_scheme(
        Goal,
        SetsMin,
        SetsMax,
        RepsMin,
        RepsMax,
        RestMin,
        RestMax
    ),
    Sets is round((SetsMin + SetsMax) / 2),
    Reps is round((RepsMin + RepsMax) / 2).


% ----- Small adjustments for special exercise types -----

% Rep-based core exercises use at least 8 repetitions.

adjust_reps_for_exercise(
    Exercise,
    BaseReps,
    Reps
) :-
    movement(Exercise, core),
    BaseReps < 8,
    !,
    Reps = 8.

% Otherwise keep the original number of repetitions.

adjust_reps_for_exercise(
    _Exercise,
    BaseReps,
    BaseReps
).


% Time-based exercises are prescribed in seconds.

timed_duration(core, beginner, 20).
timed_duration(core, intermediate, 30).

timed_duration(conditioning, beginner, 30).
timed_duration(conditioning, intermediate, 45).


% Continuous cardio exercises are prescribed in minutes.

cardio_duration(beginner, 10).
cardio_duration(intermediate, 15).



% ----- Prescription for one exercise -----

% Continuous cardio uses minutes instead of sets and repetitions.

prescribe_selected_exercise(
    Exercise,
    _Goal,
    Level,
    cardio_plan(Exercise, Minutes)
) :-
    cardio_based(Exercise),
    cardio_duration(Level, Minutes),
    !.


% Time-based exercises use sets and seconds.

prescribe_selected_exercise(
    Exercise,
    Goal,
    Level,
    timed_plan(
        Exercise,
        Sets,
        Seconds,
        RestMin,
        RestMax
    )
) :-
    time_based(Exercise),
    movement(Exercise, Role),
    timed_duration(Role, Level, Seconds),
    target_scheme(
        Goal,
        Level,
        Sets,
        _Reps,
        RestMin,
        RestMax
    ),
    !.


% Normal exercises use sets and repetitions.

prescribe_selected_exercise(
    Exercise,
    Goal,
    Level,
    exercise_plan(
        Exercise,
        Sets,
        Reps,
        RestMin,
        RestMax
    )
) :-
    exercise(Exercise),

    \+ time_based(Exercise),
    \+ cardio_based(Exercise),

    target_scheme(
        Goal,
        Level,
        Sets,
        BaseReps,
        RestMin,
        RestMax
    ),

    adjust_reps_for_exercise(
        Exercise,
        BaseReps,
        Reps
    ).



% ----- Prescription for a list of exercises -----

% Base case: no more exercises.

prescribe_exercise_list(
    [],
    _Goal,
    _Level,
    []
).


% Prescribe the first exercise and continue
% recursively with the rest of the list.

prescribe_exercise_list(
    [Exercise | RestExercises],
    Goal,
    Level,
    [ExercisePlan | RestPlans]
) :-
    prescribe_selected_exercise(
        Exercise,
        Goal,
        Level,
        ExercisePlan
    ),

    prescribe_exercise_list(
        RestExercises,
        Goal,
        Level,
        RestPlans
    ).

