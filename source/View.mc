/*============================================================================
  Minimal OLED Watch Face

  Main watch face implementation. All this class does is to keep track
    of whether we're in low power of high power mode. When the system
    calls onUpdate(), it just delegates to the appropriate displayer 
    class to handle these different types of display. So there's no 
    drawing logic in this class at all.

  Copyright (c)2018-2023 Kevin Boone
  Released under the terms of the GNU Public Licence, v3.0
============================================================================*/

using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Math;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi;
using Toybox.Application;

/** Main view class for the battery-saving watch face. */
class MOWFView extends WatchUi.WatchFace
  {
  // The system will always start us off in HP mode
  var lowPower = false;

  // Store references to the HP and LP displayer objects
  var lpDisplayer;
  var hpDisplayer;

  function initialize() 
    {
    WatchFace.initialize();
    }

  function onLayout (dc) 
    {
    // Just initialize the HP and LP displayers.
    lpDisplayer = new LPDisplayer (dc);
    hpDisplayer = new HPDisplayer (dc);
    }

  /* With OLED watches this function is called once per second, regardless
       whether we're in HP or LP mode. With earlier watches it's called
       once per second when the screen wakes, and once per minute thereafter.
     To support both OLED and LCD watches, the code needs to work properly
       in both cases. However, since this application only updates once 
       per minute, we don't need to worry too much about this. If it
       updated more often, we would need to implement onPartialUpdate(),
       but this is _only_ called by LCD watches. This is all a bit
       nasty. */
  function onUpdate (dc) 
    {
    /* Delegate to the appropriate displayer */
    if (lowPower)
      {
      lpDisplayer.onUpdate (dc);
      }
    else
      {
      hpDisplayer.onUpdate (dc);
      }
    }

  /* Not used in OLED watches. */
  function onPartialUpdate (dc) 
    {
    // Not implemented 
    }

  function onEnterSleep() 
    {
    /* Record that we are now in LP mode */
    lowPower = true;
    WatchUi.requestUpdate();
    }

  function onExitSleep() 
    {
    /* Record that we are now in HP mode */
    lowPower = false;
    WatchUi.requestUpdate();
    }
  }

/* Not used in this application. */
class MOWFDelegate extends WatchUi.WatchFaceDelegate 
  {
  function onPowerBudgetExceeded (powerInfo) 
    {
    // Not implemented -- should never happen
    }
  }

