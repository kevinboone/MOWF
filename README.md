# Minimal OLED Watch Face (MOWF)

Version 0.2, September 2023

![Screenshot](screenshot.png)

This is an extremely simple, non-configurable watch face for 
Garmin smart watches with OLED displays, like the Venu, Venu 2, and
Epix 2. Its aim is to provide an always-on display, with the lowest
practicable battery usage, and the least chance of causing screen
burn-in. Sadly, burn-in is a real problem with OLED displays, and it 
could radically reduce the lifespan of an expensive watch.

MOWF just displays a digital watch face, with time, date, and 
battery charge and, in 'high power' (awake) mode, heart rate.
Apart from the presence of the heart rate display, the other
differences between 'high power' and 'low power' mode are

- In 'high power' mode the display is white, and much larger.
  In 'low power' mode it is green, with smaller text.
- In 'low power' mode the text is moved over a much larger area of
  screen. At least half the screen will be blank at least half the time.
  In 'high power' mode the text is still moved, but my a small amount
  that should not really be noticeable. Both these kinds of movement
  are necessary to prevent screen burn-on.

MOWF is designed to run with the display set to 'always on' mode,
and short gesture timeout. It will therefore run in 'low power' mode almost
all the time, but with the time/date display visible.

## Design considerations

A practical, always-on OLED display must

- illuminate as few pixels as practicable, to reduce power consumption, and
- not illuminate any pixel for an extended period of time. This is to
  prevent burn-in.

The Garmin OLED watches have a burn-in protection system: the screen will
blank if more than 10% of pixels are illuminated in low-power mode,
or if any pixel is illuminated for more than three minutes.

Clearly, there's a trade-off between power consumption and usability. 
The display text has to be large enough to read but, the larger it is,
the more power that will be used, and the hotter the display will get.
Because the watch will only run in 'high power' mode for up to ten seconds
after a button press or wake gesture, I think we have a bit more leeway
with high power mode. So in this mode I've used much larger text.

MOWF also displays the heart rate in high power mode, and there is (I believe)
little to no cost in doing so. 
The reason is that the watch face will _require_ (on OLED models) to be
fully redrawn every second when in high-power mode. The watch does
not give the application any way to force a lower refresh rate than
that (earlier models had a one-minute update, and a one-second 'partial
update'. OLED models don't have that subtlety). Since we have to
refresh the whole screen every second in high power mode, 
we might as well write the
heart rate -- the extra 2-3 small digits won't increase power usage
significantly.

In low power mode, the display is drawn in completely 
different positions at
minute intervals, so no pixel will ever be lit for more than one minute.
MOWF also sets the text to green. The reason for this is that the
human eye is particularly sensitive to green light -- so we get
improved visibility for reduced energy. Or so I hope, anyway. I haven't
done any tests to see whether this is genuinely the case.

In high power mode, the text is moved by one pixel each minute, over a
ten-pixel range. That isn't quite enough to ensure that no pixel is lit for
more than three minutes, but it would take a lot of effort to keep the
watch awake for three minutes when only displaying a watch face. Usually
the screen timeout in high power mode is 3-10 seconds.

Note also that the always-on mode will be disabled if the watch is
not being warn, and during the user's designated sleep period. According to
Garmin this is to avoid waking the wearer from sleep, but I would
prefer the always-on mode to be available at night. This can, in principle,
be achieved by setting the designated awake period to 24 hours -- but
this interferes with sleep detection.

MOWF is not an elegant or versatile watch face. Its one goal is to
provide the lowest possible energy consumption and least chance of
burn in. I prefer an analogue watch display to a digital one, but
the computation required to draw the analogue hands -- especially if
it might be done every second -- is an needless drain on the battery.

## Building

If you're reading this, you probably already know how to build 
ConnectIQ watch face apps. 

I build at the command line like this:

```
monkeyc -o mowf.prg -y /path/to/my/certificate.der -f monkey.jungle  
```

Instructions on building at the command line are here:

https://developer.garmin.com/connect-iq/reference-guides/monkey-c-command-line-setup/


To run on the simulator:

```
siumulator &
monkeydo mowf.prg venu2 
```

## Installing

To install on a watch, just copy mowf.prg to the `/GARMIN/APPS/` directory
when the watch is mounted as a USB drive.

 
