/*============================================================================
  Minimal OLED Watch Face
  LPDisplayer
  This class contains logic for drawing the screen in low-power mode
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

class LPDisplayer extends Displayer
  {
  var bgColour;
  var fgColour;
  var totalDispHeight;
  var timeHeight;
  var dateHeight;
  var chargeHeight;
  var ticks = 0;

  function setColours ()
    {
    fgColour = Graphics.COLOR_GREEN;
    bgColour = Graphics.COLOR_BLACK;
    }

  /* Some of this initialization logic could be dragged out into a common
     base class, as it's similar in both HPDisplayer and LDDisplayer. However,
     I've kept these classes separate, because it's conceivable that they
     could display completely different things. */
  function initialize (dc)
    {
    Displayer.initialize (dc);

    timeHeight = largeFontHeight; 
    dateHeight = tinyFontHeight; 
    chargeHeight = xtinyFontHeight; 
    totalDispHeight = timeHeight + dateHeight + chargeHeight + 10;

    setColours();
    }

  function drawScreen (dc, info)
    {
    ticks++;

    // Clear screen
    dc.setColor (bgColour, fgColour); 
    dc.fillRectangle(0, 0, width, height);

    dc.setColor (fgColour, bgColour);

    var sTime = info.hour.format("%02u") + ":" + info.min.format("%02u");
    var sDate = Lang.format ("$1$ $2$", [info.day_of_week.substring (0, 3), 
      info.day]);
    var sCharge =
      (System.getSystemStats().battery + 0.5).toNumber().toString() + "%";

    var yOff;

    if (ticks % 2)
      {
      yOff = height * 0.1;
      }
    else
      {
      yOff = height * 0.6;
      }

    dc.drawText (halfWidth, yOff, Graphics.FONT_MEDIUM, sTime, 
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER); 
    dc.drawText (halfWidth, yOff + timeHeight + 5, Graphics.FONT_TINY, sDate, 
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER); 
    dc.drawText (halfWidth, yOff + timeHeight + dateHeight + 10, 
        Graphics.FONT_XTINY, sCharge, 
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER); 
    }
  }

