//A program which reads a sound file in to the sounds[] array, and 
// applies a filter to it, controlled by xbox joystick

//Left x-axis controls mix
//Right x-axis controls filter freq

// A: resonance filter
// B: Bandpass filter
// X: Low-pass
// Y: High-pass
// RB: No filter


// which joystick
0 => int device;
// get from command line
if( me.args() ) me.arg(0) => Std.atoi => device;



SndBuf s => dac;
SndBuf s2 => dac;

ResonZ r;
LPF l;
HPF h;
BPF bp;

//Set up sound array and buffer
[ INSERT YOUR SOUNDS HERE AS WAV FILES ] @=> string sounds[];

0 => s.play => s2.play;
sounds[0] => s.read;
sounds[0] => s2.read;

//Set Qs and filter gains
1 => r.Q => l.Q => h.Q => bp.Q;
1 => r.gain => l.gain => h.gain => bp.gain;

//Last hit button, to prevent doubling of filters
0 => int last;

// variables
int base;
float a0;
float a1;
float a2;
int count;

// start things
set( base, a0, a1, a2 );

// hid objects
Hid hi;
HidMsg msg;

// try
if( !hi.openJoystick( device ) ) me.exit();
<<< "joystick '" + hi.name() + "' ready...", "" >>>;

// infinite time loop
while( true )
{
    // wait on event
    hi => now;
    // loop over messages
    while( hi.recv( msg ) )
    {
        if( msg.isAxisMotion() )
        {
            if( msg.which == 0 ) msg.axisPosition => a0;
            else if( msg.which == 1 ) msg.axisPosition => a1;
            else if( msg.which == 2 ) msg.axisPosition => a2;
            set( base, a0, a1, a2 );
        }
        
        else if( msg.isButtonDown() )
        {
            msg.which => base;
            
            <<< last >>>;
            if ( ( base == 11 ) && ( last != 11 ) ) {
                
               unplug();
               s => r => dac;
                base => last;
            } else if ( ( base == 12 ) && ( last != 12 ) ) {
            
                unplug();
                s => bp => dac;
                base => last;
            } else if ( ( base == 13 ) && ( last != 13 ) ) {
                unplug();
                s => l => dac;
                base => last;
            } else if ( ( base == 14 ) && ( last != 14 ) ) {
                unplug();
         
                s => h => dac;
                base => last;
            } else if ( base == 9 ) {
                unplug();
                s => dac;
            }
            count++;
            
            set( base, a0, a1, a2 );
        }
        
        else if( msg.isButtonUp() )
        {
            msg.which => base;
            count--;
         
        }
    }
}

// mapping function
fun void set( int base, float v0, float v1, float v2 )
{
   //Begin sound buffer on hit of any button
    if ( base != 0 ) 1 => s.play => s2.play; 
    //Set gain of wet signal
    ( ( v0 + 1 ) / 2.0 ) => s.gain;
    //Set gain of dry signal
    -1 * ( ( v0 - 1 ) / 2.0 ) => s2.gain;
    //Set filter freq
    ( ( v2 + 1.25 ) * 2000 ) => r.freq => l.freq => bp.freq => h.freq;
    
}

//Unplug all from the dac
fun void unplug() {
    s =< dac;
    s =< r =< dac;
    s =< h =< dac;
    s =< l =< dac;
    s =< bp =< dac;
}