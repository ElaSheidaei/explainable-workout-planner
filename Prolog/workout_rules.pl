:- consult('compatibility_rules.pl').
:- consult('training_schemes.pl').

%Which movement slots should this workout contain, 
%and which compatible exercise can fill each slot

% Workout Structure Rules
%------------------------
% This file defines how suitable exercises are combined
% to create sessions and then a complete weekly plan.


% ----- Movement groups and Slots -----

% Push and pull are general slots that can be filled
% by either horizontal or vertical movements.

push_movement(horizontal_push).
push_movement(vertical_push).

pull_movement(horizontal_pull).
pull_movement(vertical_pull).


% % ----- Full-body workout requirements -----

% full_body_slot(squat).
% full_body_slot(hinge).
% full_body_slot(push).
% full_body_slot(pull).
% full_body_slot(core).

% Check if an exercise can fill a specific movement slot.

fills_slot(Exercise, squat) :-
    movement(Exercise, squat).

fills_slot(Exercise, hinge) :-
    movement(Exercise, hinge).

fills_slot(Exercise, push) :-
    movement(Exercise, Movement),
    push_movement(Movement).

fills_slot(Exercise, pull) :-
    movement(Exercise, Movement),
    pull_movement(Movement).

fills_slot(Exercise, core) :-
    movement(Exercise, core).

fills_slot(Exercise, lunge) :-
    movement(Exercise, lunge).

fills_slot(Exercise, horizontal_push) :-
    movement(Exercise, horizontal_push).

fills_slot(Exercise, vertical_push) :-
    movement(Exercise, vertical_push).

fills_slot(Exercise, horizontal_pull) :-
    movement(Exercise, horizontal_pull).

fills_slot(Exercise, vertical_pull) :-
    movement(Exercise, vertical_pull).

fills_slot(Exercise, conditioning) :-
    movement(Exercise, conditioning).


%--------- Find a suitable exercise for a slot -----------

% An exercise is a candidate if:
% - it is suitable for the user's level, location,
%   equipment and constraints
% - it can fill the required movement slot.

candidate_for_slot(
    Exercise,
    Slot,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints
) :-
    suitable_exercise(
        Exercise,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),
    fills_slot(Exercise, Slot).

%----------- Goal prefrences -----------

% Some exercise roles are preferred for each goal.
% These are preferences, not hard constraints.

preferred_role(strength, strength).

preferred_role(fat_loss, conditioning).

preferred_role(endurance, endurance).
preferred_role(endurance, conditioning).

preferred_role(general_fitness, strength).
preferred_role(general_fitness, conditioning).
preferred_role(general_fitness, endurance).
preferred_role(general_fitness, core).


% Check if a candidate also has a role preferred
% for the user's goal.

preferred_candidate_for_slot(
    Exercise,
    Slot,
    Goal,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints
) :-
    candidate_for_slot(
        Exercise,
        Slot,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),
    primary_role(Exercise, Role),
    preferred_role(Goal, Role).


%----------- First simple workout prototype ---------

% This was the first simple version of the planner.
% It builds a full-body workout by selecting one suitable
% exercise for each main movement slot.
%
% The later version generalizes this idea to different
% session types and complete weekly plans.

full_body_workout(
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints,
    SquatExercise,
    HingeExercise,
    PushExercise,
    PullExercise,
    CoreExercise
) :-
    candidate_for_slot(
        SquatExercise,
        squat,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),

    candidate_for_slot(
        HingeExercise,
        hinge,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),

    candidate_for_slot(
        PushExercise,
        push,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),

    candidate_for_slot(
        PullExercise,
        pull,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),

    candidate_for_slot(
        CoreExercise,
        core,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ).


% ------------ Weekly Splits ----------

% Select the weekly structure from the number of sessions
% and the user's level.

split(2, beginner, full_body).
split(2, intermediate, full_body).

split(3, beginner, full_body).
split(3, intermediate, push_pull_legs).

split(4, beginner, upper_lower).
split(4, intermediate, upper_lower).


%------------- Session Size ------------



% short_session could be one of the user's constraints.
% A short session always uses four exercises.

session_exercise_count(_, Constraints, 4) :-
    member(short_session, Constraints),
    !.

% Otherwise, the number of exercises depends on duration.

session_exercise_count(Duration, _, 4) :-
    Duration =< 30,
    !.

session_exercise_count(Duration, _, 5) :-
    Duration =< 45,
    !.

session_exercise_count(_, _, 6).



% ---------- Session Structures --------------

% Each session type is represented by a list of movement slots.
% The number of slots depends on the session duration.

% ----- Full Body -----
session_structure(full_body, 4,
    [squat, hinge, push, pull]).

session_structure(full_body, 5,
    [squat, hinge, push, pull, core]).

session_structure(full_body, 6,
    [squat, hinge, push, pull, core, conditioning]).


% ----- Push -----
session_structure(push, 4,
    [horizontal_push, vertical_push, push, core]).

session_structure(push, 5,
    [horizontal_push, vertical_push, push, conditioning, core]).

session_structure(push, 6,
    [horizontal_push, vertical_push,
     horizontal_push, push,
     conditioning, core]).


% ----- Pull -----
session_structure(pull, 4,
    [horizontal_pull, vertical_pull, pull, core]).

session_structure(pull, 5,
    [horizontal_pull, vertical_pull, pull, hinge, core]).

session_structure(pull, 6,
    [horizontal_pull, vertical_pull,
     horizontal_pull, pull,
     hinge, core]).


% ----- Legs -----
session_structure(legs, 4,
    [squat, lunge, hinge, core]).

session_structure(legs, 5,
    [squat, lunge, hinge, conditioning, core]).

session_structure(legs, 6,
    [squat, squat, lunge,
     hinge, conditioning, core]).



% ----- Upper -----
session_structure(upper, 4,
    [push, pull, push, pull]).

session_structure(upper, 5,
    [push, pull, push, pull, core]).

session_structure(upper, 6,
    [horizontal_push, horizontal_pull,
     vertical_push, push,
     pull, core]).


% ----- Lower -----
session_structure(lower, 4,
    [squat, lunge, hinge, core]).

session_structure(lower, 5,
    [squat, lunge, hinge,
     conditioning, core]).

session_structure(lower, 6,
    [squat, squat, lunge,
     hinge, conditioning, core]).



% Weekly Day Structure
%--------------------


% ----- 2-day full body -----

weekly_day(full_body, 2, 1, full_body).
weekly_day(full_body, 2, 2, full_body).


% ----- 3-day full body -----

weekly_day(full_body, 3, 1, full_body).
weekly_day(full_body, 3, 2, full_body).
weekly_day(full_body, 3, 3, full_body).


% ----- 3-day Push / Pull / Legs -----

weekly_day(push_pull_legs, 3, 1, push).
weekly_day(push_pull_legs, 3, 2, pull).
weekly_day(push_pull_legs, 3, 3, legs).


% ----- 4-day Upper / Lower -----

weekly_day(upper_lower, 4, 1, upper).
weekly_day(upper_lower, 4, 2, lower).
weekly_day(upper_lower, 4, 3, upper).
weekly_day(upper_lower, 4, 4, lower).


% Variation between sessions
%------------------------------

%variation between repeated days, while still allowing repetition when
%the knowledge base has no alternative.

% Prefer an exercise that:
% 1. fits the current slot
% 2. has not already been used in this session
% 3. has not been used in previous days

varied_candidate_for_slot(
    Exercise,
    Slot,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints,
    UsedInSession,
    UsedInWeek
) :-
    candidate_for_slot(
        Exercise,
        Slot,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),
    \+ member(Exercise, UsedInSession),
    \+ member(Exercise, UsedInWeek).


% Fallback:
% if there is NO completely new exercise available for this slot,
% allow one used on a previous day,
% but NEVER repeat it inside the same session.
varied_candidate_for_slot(
    Exercise,
    Slot,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints,
    UsedInSession,
    UsedInWeek
) :-
    \+ (
        candidate_for_slot(
            Alternative,
            Slot,
            UserLevel,
            UserLocation,
            UserEquipment,
            Constraints
        ),
        \+ member(Alternative, UsedInSession),
        \+ member(Alternative, UsedInWeek)
    ),

    candidate_for_slot(
        Exercise,
        Slot,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),

    \+ member(Exercise, UsedInSession).


% Add goal preference
%---------------------

% After adding variation, goal preference was added.
% First try a goal-preferred exercise that has not been used.

preferred_varied_candidate_for_slot(
    Exercise,
    Slot,
    Goal,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints,
    UsedInSession,
    UsedInWeek
) :-
    preferred_candidate_for_slot(
        Exercise,
        Slot,
        Goal,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),
    \+ member(Exercise, UsedInSession),
    \+ member(Exercise, UsedInWeek).


% First try the goal-preferred candidate.

goal_varied_candidate_for_slot(
    Exercise,
    Slot,
    Goal,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints,
    UsedInSession,
    UsedInWeek
) :-
    preferred_varied_candidate_for_slot(
        Exercise,
        Slot,
        Goal,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints,
        UsedInSession,
        UsedInWeek
    ).


% If there is no unused goal-preferred exercise,
% use the normal variation rule as fallback.

goal_varied_candidate_for_slot(
    Exercise,
    Slot,
    Goal,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints,
    UsedInSession,
    UsedInWeek
) :-
    \+ preferred_varied_candidate_for_slot(
        _,
        Slot,
        Goal,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints,
        UsedInSession,
        UsedInWeek
    ),

    varied_candidate_for_slot(
        Exercise,
        Slot,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints,
        UsedInSession,
        UsedInWeek
    ).



% Add level preference
%-------------------------

% The final selection version also considers the user's level.
% For example, an intermediate user first tries exercises whose
% minimum level is intermediate.
%
% Easier exercises are still compatible and can be used
% as fallback when needed.

level_preferred_candidate_for_slot(
    Exercise,
    Slot,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints
) :-
    candidate_for_slot(
        Exercise,
        Slot,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),
    min_level(Exercise, UserLevel).


% Best case:
% unused exercise that matches both level and goal preference.

goal_level_varied_candidate_for_slot(
    Exercise,
    Slot,
    Goal,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints,
    UsedInSession,
    UsedInWeek
) :-
    preferred_candidate_for_slot(
        Exercise,
        Slot,
        Goal,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),
    level_preferred_candidate_for_slot(
        Exercise,
        Slot,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),
    \+ member(Exercise, UsedInSession),
    \+ member(Exercise, UsedInWeek).


% If there is no unused exercise matching both goal and level,
% try an unused exercise that at least matches the user's level.

goal_level_varied_candidate_for_slot(
    Exercise,
    Slot,
    Goal,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints,
    UsedInSession,
    UsedInWeek
) :-
    \+ (
        preferred_candidate_for_slot(
            Alternative,
            Slot,
            Goal,
            UserLevel,
            UserLocation,
            UserEquipment,
            Constraints
        ),
        level_preferred_candidate_for_slot(
            Alternative,
            Slot,
            UserLevel,
            UserLocation,
            UserEquipment,
            Constraints
        ),
        \+ member(Alternative, UsedInSession),
        \+ member(Alternative, UsedInWeek)
    ),

    level_preferred_candidate_for_slot(
        Exercise,
        Slot,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints
    ),

    \+ member(Exercise, UsedInSession),
    \+ member(Exercise, UsedInWeek).


% Final fallback:
% if no unused exercise matches the exact level,
% use the previous goal and variation rules.

goal_level_varied_candidate_for_slot(
    Exercise,
    Slot,
    Goal,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints,
    UsedInSession,
    UsedInWeek
) :-
    \+ (
        level_preferred_candidate_for_slot(
            Alternative,
            Slot,
            UserLevel,
            UserLocation,
            UserEquipment,
            Constraints
        ),
        \+ member(Alternative, UsedInSession),
        \+ member(Alternative, UsedInWeek)
    ),

    goal_varied_candidate_for_slot(
        Exercise,
        Slot,
        Goal,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints,
        UsedInSession,
        UsedInWeek
    ).


% Build one session 
%---------------------

% Base case: there are no more movement slots to fill.

fill_slots_goal_varied(
    [],
    _Goal,
    _UserLevel,
    _UserLocation,
    _UserEquipment,
    _Constraints,
    _UsedInSession,
    _UsedInWeek,
    []
).

% Select an exercise for the first slot and then continue
% recursively with the remaining slots.

fill_slots_goal_varied(
    [Slot | RestSlots],
    Goal,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints,
    UsedInSession,
    UsedInWeek,
    [Exercise | RestExercises]
) :-
    goal_level_varied_candidate_for_slot(
        Exercise,
        Slot,
        Goal,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints,
        UsedInSession,
        UsedInWeek
    ),

    fill_slots_goal_varied(
        RestSlots,
        Goal,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints,
        [Exercise | UsedInSession],
        UsedInWeek,
        RestExercises
    ).



% Build one session:
% 1. decide how many exercises are needed
% 2. get the movement slots for that session
% 3. fill the slots with suitable exercises

build_session_goal_varied(
    DayType,
    Goal,
    Duration,
    UserLevel,
    UserLocation,
    UserEquipment,
    Constraints,
    UsedInWeek,
    Exercises
) :-
    session_exercise_count(
        Duration,
        Constraints,
        ExerciseCount
    ),

    session_structure(
        DayType,
        ExerciseCount,
        Slots
    ),

    fill_slots_goal_varied(
        Slots,
        Goal,
        UserLevel,
        UserLocation,
        UserEquipment,
        Constraints,
        [],
        UsedInWeek,
        Exercises
    ).


% Build the complete week 
%---------------------------

% Select the weekly split and start building from day 1.

build_week_goal(
    Goal,
    SessionsPerWeek,
    Level,
    Duration,
    Location,
    Equipment,
    Constraints,
    Week
) :-
    split(
        SessionsPerWeek,
        Level,
        Split
    ),

    build_week_days_goal(
        Split,
        SessionsPerWeek,
        1,
        Goal,
        Duration,
        Level,
        Location,
        Equipment,
        Constraints,
        [],
        Week
    ).


% Base case:
% stop after the requested number of training days.

build_week_days_goal(
    _Split,
    SessionsPerWeek,
    DayNumber,
    _Goal,
    _Duration,
    _Level,
    _Location,
    _Equipment,
    _Constraints,
    _UsedInWeek,
    []
) :-
    DayNumber > SessionsPerWeek,
    !.


% Build the current day and then continue with the next one.

build_week_days_goal(
    Split,
    SessionsPerWeek,
    DayNumber,
    Goal,
    Duration,
    Level,
    Location,
    Equipment,
    Constraints,
    UsedInWeek,
    [
        day(DayNumber, DayType, Exercises)
        | RestWeek
    ]
) :-
    weekly_day(
        Split,
        SessionsPerWeek,
        DayNumber,
        DayType
    ),

    build_session_goal_varied(
        DayType,
        Goal,
        Duration,
        Level,
        Location,
        Equipment,
        Constraints,
        UsedInWeek,
        Exercises
    ),

    % Remember the exercises already used in previous days.
    append(
        Exercises,
        UsedInWeek,
        UpdatedUsedInWeek
    ),

    NextDay is DayNumber + 1,

    build_week_days_goal(
        Split,
        SessionsPerWeek,
        NextDay,
        Goal,
        Duration,
        Level,
        Location,
        Equipment,
        Constraints,
        UpdatedUsedInWeek,
        RestWeek
    ).


% Add the exercise prescriptions
%-------------------------------

% Base case: no more training days.

prescribe_week(
    [],
    _Goal,
    _Level,
    []
).


% Apply sets/reps/time/rest prescriptions to every
% exercise in the current day, then continue with the next day

prescribe_week(
    [day(DayNumber, DayType, Exercises) | RestWeek],
    Goal,
    Level,
    [day(DayNumber, DayType, ExercisePlans) | RestPrescribedWeek]
) :-
    prescribe_exercise_list(
        Exercises,
        Goal,
        Level,
        ExercisePlans
    ),
    prescribe_week(
        RestWeek,
        Goal,
        Level,
        RestPrescribedWeek
    ).


% Final weekly planner.
% First construct the week and then add the prescriptions.

build_prescribed_week(
    Goal,
    SessionsPerWeek,
    Level,
    Duration,
    Location,
    Equipment,
    Constraints,
    PrescribedWeek
) :-
    build_week_goal(
        Goal,
        SessionsPerWeek,
        Level,
        Duration,
        Location,
        Equipment,
        Constraints,
        Week
    ),
    prescribe_week(
        Week,
        Goal,
        Level,
        PrescribedWeek
    ).
