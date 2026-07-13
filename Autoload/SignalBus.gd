extends Node
@warning_ignore_start("unused_signal")

# SYSTEM
signal exit_stage(stage : Stage)

# BATTLE
signal battle_start
signal battle_end(win : bool)

# UI
signal tile_hovered(tile : Tile, on : bool)
signal tile_selected(tile : Tile)

signal unit_hovered(unit : Unit, on : bool)
signal unit_selected(unit : Unit)

#signal deselect_all(except : Control)
