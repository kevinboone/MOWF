/*============================================================================
  Minimal OLED Watch Face

  Displayer

  Base class for high-power and low-power displayers. This class
    includes basic functionality that is common to both HP and LP display
    modes, like storing the screen and font sizes for later use.

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

class Displayer
  {
  var displayHelper;
  var width;
  var height;
  var halfWidth;
  var halfHeight;
  var xtinyFontHeight;
  var tinyFontHeight;
  var smallFontHeight;
  var mediumFontHeight;
  var largeFontHeight;
  var hugeFontHeight;
  var offscreenBuffer;
  var screenCentrePoint;

  function drawScreen (dc, info) {}

  function initialize (dc)
    {
    displayHelper = DisplayHelper.get();

    width = dc.getWidth();
    height = dc.getHeight();
    halfWidth = width / 2;
    halfHeight = height / 2;

    hugeFontHeight = dc.getFontHeight (Graphics.FONT_NUMBER_THAI_HOT);
    largeFontHeight = dc.getFontHeight (Graphics.FONT_MEDIUM);
    mediumFontHeight = dc.getFontHeight (Graphics.FONT_MEDIUM);
    smallFontHeight = dc.getFontHeight (Graphics.FONT_SMALL);
    tinyFontHeight = dc.getFontHeight (Graphics.FONT_TINY);
    xtinyFontHeight = dc.getFontHeight (Graphics.FONT_XTINY);
 
    screenCentrePoint = [dc.getWidth() / 2, dc.getHeight() / 2];

    offscreenBuffer = displayHelper.getOffscreenBuffer(dc);
    }

  /* onUpdate() should be called whenever the system calls onUpdate() on
       the main view class. It calls the abstract drawScreen() method, and
       takes care of manipulating the off-screen buffer, if there is one. */
  function onUpdate (dc) 
    {
    var info = Gregorian.info (Time.now(), Time.FORMAT_LONG);
    var targetDc = null;
    if (null != offscreenBuffer) 
      {
      dc.clearClip ();
      targetDc = offscreenBuffer.getDc();
      } 
    else 
      {
      targetDc = dc;
      }

    drawScreen (targetDc, info);

    // If we're working with an off-screen buffer, transfer the
    // buffer to the string. If not, there's nothing else to do --
    // screen has already been drawn
    if (null != offscreenBuffer) 
      {
      dc.drawBitmap (0, 0, offscreenBuffer);
      }
    }

  function getHRString()
    {
    var s_hr = "--";
    if (Toybox.ActivityMonitor has :getHeartRateHistory)
      {
      var heartRate = Activity.getActivityInfo().currentHeartRate;

      if (heartRate == null) 
        {
        var hrh = Toybox.ActivityMonitor.getHeartRateHistory (1, true);
        var hrs = hrh.next();
        if (hrs != null && 
            hrs.heartRate != Toybox.ActivityMonitor.INVALID_HR_SAMPLE)
          {
          heartRate = hrs.heartRate;
          }
        }
      if (heartRate != null)
        {
        s_hr = heartRate.toString();
        }
      }
     return s_hr;
    }
  }

