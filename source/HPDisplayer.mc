/*============================================================================
  Minimal OLED Watch Face
  HPDisplayer
  This class contains logic for drawing the screen in high-power mode
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

class HPDisplayer extends Displayer
  {
  var bgColour;
  var fgColour;
  var totalDispHeight;
  var timeHeight;
  var dateHeight;
  var chargeHeight;

  function setColours ()
    {
    fgColour = Graphics.COLOR_WHITE;
    bgColour = Graphics.COLOR_BLACK;
    }

  function initialize (dc)
    {
    Displayer.initialize (dc);

    timeHeight = hugeFontHeight; 
    dateHeight = tinyFontHeight; 
    chargeHeight = xtinyFontHeight; 
    totalDispHeight = timeHeight + dateHeight + chargeHeight + 10;

    setColours();
    }

  function drawScreen (dc, info)
    {
    var s_hr = getHRString();

    // Clear screen
    dc.setColor (bgColour, fgColour); 
    dc.fillRectangle(0, 0, width, height);

    dc.setColor (fgColour, bgColour);

    var sTime = info.hour.format("%02u") + ":" + info.min.format("%02u");
    var sDate = Lang.format ("$1$ $2$", [info.day_of_week.substring (0, 3), 
      info.day]);
    var sCharge = s_hr + " | " + 
      (System.getSystemStats().battery + 0.5).toNumber().toString() + "%";

    var minOffset = info.min % 10 - 5;
    var yOff = halfHeight - (totalDispHeight / 2 + minOffset);

    dc.drawText (halfWidth + minOffset, yOff, 
      Graphics.FONT_NUMBER_THAI_HOT, sTime, 
      Graphics.TEXT_JUSTIFY_CENTER); 
    dc.drawText (halfWidth + minOffset, yOff + timeHeight + 5, 
      Graphics.FONT_TINY, sDate, 
      Graphics.TEXT_JUSTIFY_CENTER); 
    dc.drawText (halfWidth + minOffset, yOff + timeHeight + dateHeight + 10, 
      Graphics.FONT_XTINY, sCharge, 
      Graphics.TEXT_JUSTIFY_CENTER); 
    }
  }

