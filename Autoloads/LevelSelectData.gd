extends Node


var nodes = []
var path_taken = []
var area_id = 1

#generation data
var cols = 7
var main_paths = 3
var extra_paths = 8
var special_rooms = ["shop", "scavenge", "scavenge", "shop", "scavenge"]

var scavenge_pool = []
var combat_pool = []
