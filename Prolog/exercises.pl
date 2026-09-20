% Exercise Knowledge Base
%------------------------
% Each exercise is described using simple properties.
% These properties are later used by the compatibility
% and workout construction rules.

% ----- Exercises -----

exercise(bodyweight_squat).
exercise(jump_squat).
exercise(glute_bridge).
exercise(push_up).
exercise(treadmill_running).
exercise(reverse_lunge).
exercise(plank).
exercise(goblet_squat).
exercise(one_arm_dumbbell_row).
exercise(lat_pulldown).
exercise(bulgarian_split_squat).
exercise(single_leg_rdl).
exercise(pike_push_up).
exercise(mountain_climber).
exercise(burpee).
exercise(brisk_walking).
exercise(dumbbell_rdl).
exercise(dumbbell_chest_press).
exercise(dumbbell_shoulder_press).
exercise(seated_cable_row).
exercise(inverted_row).


% Additional exercises added during testing to improve
% the coverage of different movement and constraint combinations.

exercise(incline_push_up).
exercise(incline_pike_push_up).
exercise(standing_knee_raise).

exercise(wall_sit).
exercise(bodyweight_deadlift).
exercise(good_morning).
exercise(walking_lunge).

exercise(wall_push_up).
exercise(bench_press).
exercise(machine_chest_press).
exercise(machine_shoulder_press).

exercise(assisted_pull_up).
exercise(pull_up).
exercise(face_pull).
exercise(straight_arm_pulldown).

exercise(crunch).
exercise(dead_bug).

exercise(jumping_jack).
exercise(high_knees).

exercise(barbell_deadlift).

exercise(smith_machine_squat).


% ----- Movement patterns -----

movement(bodyweight_squat, squat).
movement(jump_squat, squat).
movement(glute_bridge, hinge).
movement(push_up, horizontal_push).
movement(treadmill_running, conditioning).
movement(reverse_lunge, lunge).
movement(plank, core).
movement(goblet_squat, squat).
movement(one_arm_dumbbell_row, horizontal_pull).
movement(lat_pulldown, vertical_pull).
movement(bulgarian_split_squat, squat).
movement(single_leg_rdl, hinge).
movement(pike_push_up, vertical_push).
movement(mountain_climber, conditioning).
movement(burpee, conditioning).
movement(brisk_walking, conditioning).
movement(dumbbell_rdl, hinge).
movement(dumbbell_chest_press, horizontal_push).
movement(dumbbell_shoulder_press, vertical_push).
movement(seated_cable_row, horizontal_pull).
movement(inverted_row, horizontal_pull).

movement(incline_push_up, horizontal_push).
movement(incline_pike_push_up, vertical_push).
movement(standing_knee_raise, core).

movement(wall_sit, squat).
movement(bodyweight_deadlift, hinge).
movement(good_morning, hinge).
movement(walking_lunge, lunge).

movement(wall_push_up, horizontal_push).
movement(bench_press, horizontal_push).
movement(machine_chest_press, horizontal_push).
movement(machine_shoulder_press, vertical_push).

movement(assisted_pull_up, vertical_pull).
movement(pull_up, vertical_pull).
movement(face_pull, horizontal_pull).
movement(straight_arm_pulldown, vertical_pull).

movement(crunch, core).
movement(dead_bug, core).

movement(jumping_jack, conditioning).
movement(high_knees, conditioning).

movement(barbell_deadlift, hinge).

movement(smith_machine_squat, squat).

% ----- Primary roles -----

primary_role(bodyweight_squat, strength).
primary_role(jump_squat, conditioning).
primary_role(glute_bridge, strength).
primary_role(push_up, strength).
primary_role(treadmill_running, endurance).
primary_role(reverse_lunge, strength).
primary_role(plank, core).
primary_role(goblet_squat, strength).
primary_role(one_arm_dumbbell_row, strength).
primary_role(lat_pulldown, strength).
primary_role(bulgarian_split_squat, strength).
primary_role(single_leg_rdl, strength).
primary_role(pike_push_up, strength).
primary_role(mountain_climber, conditioning).
primary_role(burpee, conditioning).
primary_role(brisk_walking, endurance).
primary_role(dumbbell_rdl, strength).
primary_role(dumbbell_chest_press, strength).
primary_role(dumbbell_shoulder_press, strength).
primary_role(seated_cable_row, strength).
primary_role(inverted_row, strength).

primary_role(incline_push_up, strength).
primary_role(incline_pike_push_up, strength).
primary_role(standing_knee_raise, core).

primary_role(wall_sit, strength).
primary_role(bodyweight_deadlift, strength).
primary_role(good_morning, strength).
primary_role(walking_lunge, strength).

primary_role(wall_push_up, strength).
primary_role(bench_press, strength).
primary_role(machine_chest_press, strength).
primary_role(machine_shoulder_press, strength).

primary_role(assisted_pull_up, strength).
primary_role(pull_up, strength).
primary_role(face_pull, strength).
primary_role(straight_arm_pulldown, strength).

primary_role(crunch, core).
primary_role(dead_bug, core).

primary_role(jumping_jack, conditioning).
primary_role(high_knees, conditioning).

primary_role(barbell_deadlift, strength).

primary_role(smith_machine_squat, strength).


% ----- Required equipment -----

requires_equipment(bodyweight_squat, none).
requires_equipment(jump_squat, none).
requires_equipment(glute_bridge, none).
requires_equipment(push_up, none).
requires_equipment(treadmill_running, gym).
requires_equipment(reverse_lunge, none).
requires_equipment(plank, none).
requires_equipment(goblet_squat, dumbbells).
requires_equipment(one_arm_dumbbell_row, dumbbells).
requires_equipment(lat_pulldown, gym).
requires_equipment(bulgarian_split_squat, none).
requires_equipment(single_leg_rdl, none).
requires_equipment(pike_push_up, none).
requires_equipment(mountain_climber, none).
requires_equipment(burpee, none).
requires_equipment(brisk_walking, none).
requires_equipment(dumbbell_rdl, dumbbells).
requires_equipment(dumbbell_chest_press, dumbbells).
requires_equipment(dumbbell_shoulder_press, dumbbells).
requires_equipment(seated_cable_row, gym).
requires_equipment(inverted_row, none).

requires_equipment(incline_push_up, none).
requires_equipment(incline_pike_push_up, none).
requires_equipment(standing_knee_raise, none).

requires_equipment(wall_sit, none).
requires_equipment(bodyweight_deadlift, none).
requires_equipment(good_morning, none).
requires_equipment(walking_lunge, none).

requires_equipment(wall_push_up, none).
requires_equipment(bench_press, gym).
requires_equipment(machine_chest_press, gym).
requires_equipment(machine_shoulder_press, gym).

requires_equipment(assisted_pull_up, gym).
requires_equipment(pull_up, gym).
requires_equipment(face_pull, gym).
requires_equipment(straight_arm_pulldown, gym).

requires_equipment(crunch, none).
requires_equipment(dead_bug, none).

requires_equipment(jumping_jack, none).
requires_equipment(high_knees, none).

requires_equipment(barbell_deadlift, gym).

requires_equipment(smith_machine_squat, gym).


% ----- Location compatibility -----

location(bodyweight_squat, home).
location(bodyweight_squat, gym).

location(jump_squat, home).
location(jump_squat, gym).

location(glute_bridge, home).
location(glute_bridge, gym).

location(push_up, home).
location(push_up, gym).

location(treadmill_running, gym).

location(reverse_lunge, home).
location(reverse_lunge, gym).

location(plank, home).
location(plank, gym).

location(goblet_squat, home).
location(goblet_squat, gym).

location(one_arm_dumbbell_row, home).
location(one_arm_dumbbell_row, gym).

location(lat_pulldown, gym).

location(bulgarian_split_squat, home).
location(bulgarian_split_squat, gym).

location(single_leg_rdl, home).
location(single_leg_rdl, gym).

location(pike_push_up, home).
location(pike_push_up, gym).

location(mountain_climber, home).
location(mountain_climber, gym).

location(burpee, home).
location(burpee, gym).

location(brisk_walking, home).
location(brisk_walking, gym).

location(dumbbell_rdl, home).
location(dumbbell_rdl, gym).

location(dumbbell_chest_press, home).
location(dumbbell_chest_press, gym).

location(dumbbell_shoulder_press, home).
location(dumbbell_shoulder_press, gym).

location(seated_cable_row, gym).

location(inverted_row, home).
location(inverted_row, gym).

location(incline_push_up, home).
location(incline_push_up, gym).

location(incline_pike_push_up, home).
location(incline_pike_push_up, gym).

location(standing_knee_raise, home).
location(standing_knee_raise, gym).

location(wall_sit, home).
location(wall_sit, gym).

location(bodyweight_deadlift, home).
location(bodyweight_deadlift, gym).

location(good_morning, home).
location(good_morning, gym).

location(walking_lunge, home).
location(walking_lunge, gym).

location(wall_push_up, home).
location(wall_push_up, gym).

location(bench_press, gym).

location(machine_chest_press, gym).

location(machine_shoulder_press, gym).

location(assisted_pull_up, gym).

location(pull_up, gym).

location(face_pull, gym).

location(straight_arm_pulldown, gym).

location(crunch, home).
location(crunch, gym).

location(dead_bug, home).
location(dead_bug, gym).

location(jumping_jack, home).
location(jumping_jack, gym).

location(high_knees, home).
location(high_knees, gym).

location(barbell_deadlift, gym).

location(smith_machine_squat, gym).


% ----- Impact -----

impact(bodyweight_squat, low).
impact(jump_squat, high).
impact(glute_bridge, low).
impact(push_up, low).
impact(treadmill_running, high).
impact(reverse_lunge, low).
impact(plank, low).
impact(goblet_squat, low).
impact(one_arm_dumbbell_row, low).
impact(lat_pulldown, low).
impact(bulgarian_split_squat, low).
impact(single_leg_rdl, low).
impact(pike_push_up, low).
impact(mountain_climber, high).
impact(burpee, high).
impact(brisk_walking, low).
impact(dumbbell_rdl, low).
impact(dumbbell_chest_press, low).
impact(dumbbell_shoulder_press, low).
impact(seated_cable_row, low).
impact(inverted_row, low).

impact(incline_push_up, low).
impact(incline_pike_push_up, low).
impact(standing_knee_raise, low).

impact(wall_sit, low).
impact(bodyweight_deadlift, low).
impact(good_morning, low).
impact(walking_lunge, low).

impact(wall_push_up, low).
impact(bench_press, low).
impact(machine_chest_press, low).
impact(machine_shoulder_press, low).

impact(assisted_pull_up, low).
impact(pull_up, low).
impact(face_pull, low).
impact(straight_arm_pulldown, low).

impact(crunch, low).
impact(dead_bug, low).

impact(jumping_jack, high).
impact(high_knees, high).

impact(barbell_deadlift, low).

impact(smith_machine_squat, low).


% ----- Floor exercises -----

floor_exercise(bodyweight_squat, no).
floor_exercise(jump_squat, no).
floor_exercise(glute_bridge, yes).
floor_exercise(push_up, yes).
floor_exercise(treadmill_running, no).
floor_exercise(reverse_lunge, no).
floor_exercise(plank, yes).
floor_exercise(goblet_squat, no).
floor_exercise(one_arm_dumbbell_row, no).
floor_exercise(lat_pulldown, no).
floor_exercise(bulgarian_split_squat, no).
floor_exercise(single_leg_rdl, no).
floor_exercise(pike_push_up, yes).
floor_exercise(mountain_climber, yes).
floor_exercise(burpee, yes).
floor_exercise(brisk_walking, no).
floor_exercise(dumbbell_rdl, no).
floor_exercise(dumbbell_chest_press, no).
floor_exercise(dumbbell_shoulder_press, no).
floor_exercise(seated_cable_row, no).
floor_exercise(inverted_row, no).

floor_exercise(incline_push_up, no).
floor_exercise(incline_pike_push_up, no).
floor_exercise(standing_knee_raise, no). 

floor_exercise(wall_sit, no).
floor_exercise(bodyweight_deadlift, no).
floor_exercise(good_morning, no).
floor_exercise(walking_lunge, no).

floor_exercise(wall_push_up, no).
floor_exercise(bench_press, no).
floor_exercise(machine_chest_press, no).
floor_exercise(machine_shoulder_press, no).

floor_exercise(assisted_pull_up, no).
floor_exercise(pull_up, no).
floor_exercise(face_pull, no).
floor_exercise(straight_arm_pulldown, no).

floor_exercise(crunch, yes).
floor_exercise(dead_bug, yes).

floor_exercise(jumping_jack, no).
floor_exercise(high_knees, no).

floor_exercise(barbell_deadlift, no).

floor_exercise(smith_machine_squat, no).

% ----- Running exercises -----

running_exercise(bodyweight_squat, no).
running_exercise(jump_squat, no).
running_exercise(glute_bridge, no).
running_exercise(push_up, no).
running_exercise(treadmill_running, yes).
running_exercise(reverse_lunge, no).
running_exercise(plank, no).
running_exercise(goblet_squat, no).
running_exercise(one_arm_dumbbell_row, no).
running_exercise(lat_pulldown, no).
running_exercise(bulgarian_split_squat, no).
running_exercise(single_leg_rdl, no).
running_exercise(pike_push_up, no).
running_exercise(mountain_climber, no).
running_exercise(burpee, no).
running_exercise(brisk_walking, no).
running_exercise(dumbbell_rdl, no).
running_exercise(dumbbell_chest_press, no).
running_exercise(dumbbell_shoulder_press, no).
running_exercise(seated_cable_row, no).
running_exercise(inverted_row, no).

running_exercise(incline_push_up, no).
running_exercise(incline_pike_push_up, no).
running_exercise(standing_knee_raise, no).

running_exercise(wall_sit, no).
running_exercise(bodyweight_deadlift, no).
running_exercise(good_morning, no).
running_exercise(walking_lunge, no).

running_exercise(wall_push_up, no).
running_exercise(bench_press, no).
running_exercise(machine_chest_press, no).
running_exercise(machine_shoulder_press, no).

running_exercise(assisted_pull_up, no).
running_exercise(pull_up, no).
running_exercise(face_pull, no).
running_exercise(straight_arm_pulldown, no).

running_exercise(crunch, no).
running_exercise(dead_bug, no).

running_exercise(jumping_jack, no).
running_exercise(high_knees, no).

running_exercise(barbell_deadlift, no).

running_exercise(smith_machine_squat, no).

% ----- Minimum user level -----

min_level(bodyweight_squat, beginner).
min_level(jump_squat, intermediate).
min_level(glute_bridge, beginner).
min_level(push_up, beginner).
min_level(treadmill_running, beginner).
min_level(reverse_lunge, beginner).
min_level(plank, beginner).
min_level(goblet_squat, beginner).
min_level(one_arm_dumbbell_row, beginner).
min_level(lat_pulldown, beginner).
min_level(bulgarian_split_squat, intermediate).
min_level(single_leg_rdl, intermediate).
min_level(pike_push_up, intermediate).
min_level(mountain_climber, beginner).
min_level(burpee, intermediate).
min_level(brisk_walking, beginner).
min_level(dumbbell_rdl, beginner).
min_level(dumbbell_chest_press, beginner).
min_level(dumbbell_shoulder_press, beginner).
min_level(seated_cable_row, beginner).
min_level(inverted_row, beginner).

min_level(incline_push_up, beginner).
min_level(incline_pike_push_up, beginner).
min_level(standing_knee_raise, beginner).

min_level(wall_sit, beginner).
min_level(bodyweight_deadlift, beginner).
min_level(good_morning, beginner).
min_level(walking_lunge, beginner).

min_level(wall_push_up, beginner).
min_level(bench_press, beginner).
min_level(machine_chest_press, beginner).
min_level(machine_shoulder_press, beginner).

min_level(assisted_pull_up, beginner).
min_level(pull_up, intermediate).
min_level(face_pull, beginner).
min_level(straight_arm_pulldown, beginner).

min_level(crunch, beginner).
min_level(dead_bug, beginner).

min_level(jumping_jack, beginner).
min_level(high_knees, beginner).

min_level(barbell_deadlift, intermediate).

min_level(smith_machine_squat, intermediate).


% Exercises prescribed by time rather than repetitions.
time_based(plank).
time_based(mountain_climber).
time_based(jumping_jack).
time_based(high_knees).
time_based(standing_knee_raise).

% Continuous cardio exercises are prescribed in minutes.
cardio_based(brisk_walking).
cardio_based(treadmill_running).