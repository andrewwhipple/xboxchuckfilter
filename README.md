xboxchuckfilter
===============
A ChucK script that plays a wav file and runs it through a series of filters, controllable by an Xbox joystick.

To use:
1) Add the file paths of the sound you want to play in the assignment to the sounds[] array
2) Run the script (either command line or in miniaudicle)
3) Potentially remap controls if needed.
4) Mess around with some filters.

Current mapping:
-Press any button to start the sound
-X-axis of the left stick controls dry/wet mix (All the way to the left: no filter, all the way to the right: all filter)
-X-axis of the right stick controls filter frequency (low to hi)
-X selects a low-pass filter
-Y selects a hi-pass filter
-A selects a resonance filter
-B selects a bandpass filter
-RB removes all filters