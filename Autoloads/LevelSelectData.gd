extends Node


var nodes = []
var path_taken = []
var area_id = 1

#generation data
var cols = 7
var main_paths = 3
var extra_paths = 8
var special_rooms = ["shop", "scavenge", "scavenge", "shop", "scavenge"]

var scavenge_pool = ["Beach_Locked_1", "Beach_Maze", "Lab_SnakeWay", "Dungeon_DeadSimple"]
var combat_pool = ["Beach_Locked_1", "Beach_Maze", "Lab_SnakeWay", "Dungeon_DeadSimple"]
