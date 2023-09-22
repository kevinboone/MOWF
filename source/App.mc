/*============================================================================
  Minimal OLED Watch Face

  App

  Copyright (c)2018-2023 Kevin Boone
  Released under the terms of the GNU Public Licence, v3.0
============================================================================*/
using Toybox.Application;
using Toybox.Time;
using Toybox.Communications;

/** Application class for the battery-saving watch face. This class
    contains almost entirely boilerplate code. */
class MOWF extends Application.AppBase
  {
  function initialize() 
    {
    AppBase.initialize();
    }

  function onStart (state) 
    {
    }

  function onStop(state)  
    {
    }

  function getInitialView() 
    {
    if (Toybox.WatchUi has :WatchFaceDelegate) 
      {
      // Do we need this delegate stuff, if we're not 
      //  handling seconds?
      return [new MOWFView(), new MOWFDelegate()];
      } 
    else 
      {
      return [new MOWFView()];
      }
    }

  function getGoalView(goal) 
    {
    return null;  // Use system default handling
    }
  }
