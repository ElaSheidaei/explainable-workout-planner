:- consult('exercises.pl').


% Compatibility Rules
%---------------------

% These rules check which exercises can be used
% for a specific user.


% ----- Equipment compatibility -----

% A user can also use exercises that require less equipment.
% For example, a user at the gym can perform bodyweight,
% dumbbell and gym exercises.

%equipment_compatible(UserEquipment, ExerciseRequirement)
equipment_compatible(none, none).

equipment_compatible(dumbbells, none).
equipment_compatible(dumbbells, dumbbells).

equipment_compatible(gym, none).
equipment_compatible(gym, dumbbells).
equipment_compatible(gym, gym).


% ----- Level compatibility -----

% Beginners can use beginner exercises.
% Intermediate users can use both beginner
% and intermediate exercises.


%level_compatible(UserLevel, RequiredLevel)
level_compatible(beginner, beginner).

level_compatible(intermediate, beginner).
level_compatible(intermediate, intermediate).


% ----- Basic compatibility -----

% Check level, location and equipment before considering
% the user's additional constraints.

basic_compatible(Exercise, UserLevel, UserLocation, UserEquipment) :-
    exercise(Exercise),
    min_level(Exercise, RequiredLevel),
    level_compatible(UserLevel, RequiredLevel),
    location(Exercise, UserLocation),
    requires_equipment(Exercise, RequiredEquipment),
    equipment_compatible(UserEquipment, RequiredEquipment).


% ----- Constraint rules -----

% These rules describe when an exercise violates
% one of the supported constraints.

% ex: An exercise violates the no_high_impact constraint
% if its impact is high.

violates_constraint(Exercise, no_high_impact) :-
    impact(Exercise, high).

violates_constraint(Exercise, no_floor_exercises) :-
    floor_exercise(Exercise, yes).

violates_constraint(Exercise, no_running) :-
    running_exercise(Exercise, yes).


%an exercise is compatible with one constraint
%if it does not violate it.

constraint_compatible(Exercise, Constraint) :-
    \+ violates_constraint(Exercise, Constraint).



% ----- Multiple constraints -----

% Base case: there are no more constraints to check.

constraints_compatible(_, []).

% Check the first constraint and then continue
% recursively with the rest of the list.

constraints_compatible(Exercise, [Constraint | Rest]) :-
    constraint_compatible(Exercise, Constraint),
    constraints_compatible(Exercise, Rest).


% ----- Final suitability rules -----

% An exercise is suitable when it passes both
% the basic compatibility rules and all constraints.

suitable_exercise(Exercise, UserLevel, UserLocation, UserEquipment, Constraints) :-
    basic_compatible(Exercise, UserLevel, UserLocation, UserEquipment),
    constraints_compatible(Exercise, Constraints).



