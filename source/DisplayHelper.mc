/*============================================================================
  Minimal OLED Watch Face

  DisplayHelper

  This is a singleton class, whose main function is to manage the 
    off-screen buffer, to make screen updates smoother. Not all watches
    support an off-screen buffer, so client classes need to watch out
    for this.

  This class is a singleton so that it only holds one off-screen buffer,
    which will be shared between display modes. Those watches that do
    support off-screen buffers only have enough memory for one
    (Venu 2 seems to have enough memory for two, but I'm not sure how
    common that is).  

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

class DisplayHelper
  {
  static var instance = null;
  var offscreenBuffer = null;

  static function get()
    {
    if (instance == null)
      {
      instance = new DisplayHelper();
      }
    return instance;
    }

  function getOffscreenBuffer(dc)
    {
    if (offscreenBuffer != null) { return offscreenBuffer; }

    offscreenBuffer = null;

    /* If we can use an off-screen buffer to build the screen display,
       then do. If not, draw direct to the screen. */

    /* Buffered bitmap support has changed completely in recent 
       (Venu-era) devices. This change is poorly documented, and some of
       the sample applications from the Garmin SDK fail on these devices :/
       Sigh. So we have to create the offscreen buffer in various different
       ways. */
    if (Toybox.Graphics has :createBufferedBitmap) /* Test this first */ 
      {
      offscreenBuffer = Graphics.createBufferedBitmap({
                :width=>dc.getWidth(),
                :height=>dc.getHeight()});
      offscreenBuffer = offscreenBuffer.get(); // Ugh. Nasty workaround. 
      }
    else if (Toybox.Graphics has :BufferedBitmap)  
      {
      /* Post-Venu, invoking this constructor fails, even though it seems
         to exist. Nice one, Garmin :/ */
      offscreenBuffer = new Graphics.BufferedBitmap({
                :width=>dc.getWidth(),
                :height=>dc.getHeight()});
      } 
    else 
      {
      offscreenBuffer = null;
      }
    return offscreenBuffer;
    }
  }

