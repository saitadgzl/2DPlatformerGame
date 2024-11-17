extends GPUParticles2D

# Function to show the particle system for 5 seconds
func show_and_hide():
	# Start emitting particles
	self.emitting = true
	# Set a timer to hide the particle system after 5 seconds
	$TimerFallEffect.start()

func _ready():
	# Call the function to show and hide the particle system
	show_and_hide()


func _on_timer_fall_effect_timeout():
	self.emitting = false
