class_name Gameplay
extends Node2D

enum BackgroundVariant {
	Light,
	Dark
}

var background_variant: Gameplay.BackgroundVariant

func _ready() -> void:
	var variant = load("res://assets/resources/background_light.tres") \
		if background_variant == Gameplay.BackgroundVariant.Light \
		else load("res://assets/resources/background_dark.tres")
	(%Background as Background).variant = variant
