import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Weather;
import Toybox.Activity;
import Toybox.ActivityMonitor;
import Toybox.Time.Gregorian;

class VirtualPetNothingView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }


    function onLayout(dc as Dc) as Void {
        //setLayout(Rez.Layouts.WatchFace(dc));
    }

 
    function onShow() as Void {
    }

    
    function onUpdate(dc as Dc) as Void {
        var mySettings = System.getDeviceSettings();
       var myStats = System.getSystemStats();
       var info = ActivityMonitor.getInfo();
       var timeFormat = "$1$:$2$";
       var clockTime = System.getClockTime();
       var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
              var hours = clockTime.hour;
               if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {   
                timeFormat = "$1$:$2$";
                hours = hours.format("%02d");  
        }
        //var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        //var weekdayArray = ["Day", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"] as Array<String>;
       // var monthArray = ["Month", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"] as Array<String>;
        var monthArraySQ = ["Month", "Jan", "Feb", "March", "April", "May", "June", "July", "Aug", "Sept", "Oct", "Nov", "Dec"] as Array<String>;
 var userBattery = "-";
   if (myStats.battery != null){userBattery = Lang.format("$1$",[((myStats.battery.toNumber())).format("%2d")]);}else{userBattery="-";} 

   var userSTEPS = 9000;
   //if (info.steps != null){userSTEPS = info.steps.toNumber();}else{userSTEPS=0;} 

  var userNotify = "-";
   if (mySettings.notificationCount != null){userNotify = Lang.format("$1$",[((mySettings.notificationCount.toNumber())).format("%2d")]);}else{userNotify="-";} 

var userAlarm = "-";
   if (mySettings.alarmCount != null){userAlarm = Lang.format("$1$",[((mySettings.alarmCount.toNumber())).format("%2d")]);}else{userAlarm="-";} 

     var userCAL = 0;
   if (info.calories != null){userCAL = info.calories.toNumber();}else{userCAL=0;}  
   

    var timeStamp= new Time.Moment(Time.today().value());
   var getCC = Toybox.Weather.getCurrentConditions();
    var TEMP = "--";
    var FC = "-";
     if(getCC != null && getCC.temperature!=null){     
        if (System.getDeviceSettings().temperatureUnits == 0){  
    FC = "C";
    TEMP = getCC.temperature.format("%d");
    }else{
    TEMP = (((getCC.temperature*9)/5)+32).format("%d"); 
    FC = "F";   
    }}
     else {TEMP = "--";}
    
    var cond;
    if (getCC != null){ cond = getCC.condition.toNumber();}
    else{cond = 0;}//sun
    
var positions;
        if (Toybox.Weather.getCurrentConditions().observationLocationPosition == null){
        positions=new Position.Location( 
    {
        :latitude => 33.684566,
        :longitude => -117.826508,
        :format => :degrees
    }
    );
    }else{
      positions= Toybox.Weather.getCurrentConditions().observationLocationPosition;
    }
    
  

 

   //Get and show Heart Rate Amount

var userHEART = "--";
if (getHeartRate() == null){userHEART = "--";}
else if(getHeartRate() == 255){userHEART = "--";}
else{userHEART = getHeartRate().toString();}

       var centerX = (dc.getWidth()) / 2;
       var centerY = (dc.getHeight()) / 2;

var stepgoal = 0;
      if (userSTEPS < 3000){stepgoal=0;}
      else if((userSTEPS > 3000) && (userSTEPS < 6000)){stepgoal=1;}
      else if(userSTEPS > 6000){stepgoal=2;}
      else{stepgoal = 1;} 

       var dog = dogPhase(stepgoal);
       var cat = dogPhase2(today.sec, stepgoal);
       //var object = object(today.day, today.sec);//today.day
       var smallFont =  WatchUi.loadResource( Rez.Fonts.smallFont );
       var wordFont =  WatchUi.loadResource( Rez.Fonts.smallFont );
       var LargeFont =  WatchUi.loadResource( Rez.Fonts.BigFont );
       var small =  WatchUi.loadResource( Rez.Fonts.smallFont );
       var xsmall =  WatchUi.loadResource( Rez.Fonts.xsmallFont );
        var rainbow = [0x48FF35,0x9AFF90,0xFF5500,0xFFB2EB,0x9AFFFB,0x48FF35,0xEF1EB8,0x00F7EE,0x00FF00,0xAA00FF,0xFF0000,0xFFAA00,0xF49B7B,0xE7A8FF,0xFFFF35,0xFFB200,0xEE748B,0xFFE900];
      View.onUpdate(dc);
   //use userSTEPS >= 0 for testing, userSTEPS >= 3000
       dog.draw(dc);
         dc.setColor(0xFFFFFF, Graphics.COLOR_TRANSPARENT);
       dc.fillEllipse(centerX*1.1, centerY*0.5, centerX*0.23, centerY*0.08);
         dc.setColor(rainbow[today.min%18], Graphics.COLOR_TRANSPARENT);
         if (today.min%2 == 1){
         dc.fillEllipse(centerX*(0.93 + (today.sec%12)*0.01), centerY*0.5, centerX*0.04, centerY*0.08);
         dc.fillEllipse(centerX*(1.13 + (today.sec%12)*0.01), centerY*0.5, centerX*0.04, centerY*0.08);
         }else {
          dc.fillEllipse(centerX*(1.05 - (today.sec%12)*0.01), centerY*0.5, centerX*0.04, centerY*0.08);
         dc.fillEllipse(centerX*(1.25 - (today.sec%12)*0.01), centerY*0.5, centerX*0.04, centerY*0.08);
         }
       cat.draw(dc);
         dc.setColor(0x000000, Graphics.COLOR_TRANSPARENT);
       dc.drawText(centerX*0.6, centerY*0.35,LargeFont, hours.format("%02d"),  Graphics.TEXT_JUSTIFY_CENTER  );
       dc.drawText(centerX*0.63, centerY*0.63,LargeFont, clockTime.min.format("%02d"),  Graphics.TEXT_JUSTIFY_CENTER  );
dc.drawText( centerX*1.5, centerY*0.4, wordFont,  ("!"+userCAL), Graphics.TEXT_JUSTIFY_LEFT );
dc.drawText( centerX*1.72, centerY*0.55, wordFont,  ("^"+userHEART), Graphics.TEXT_JUSTIFY_LEFT );
dc.drawText( centerX*1.8, centerY*0.7, wordFont,  ("*"+userBattery), Graphics.TEXT_JUSTIFY_LEFT );
dc.drawText( centerX*1.82, centerY*0.86, wordFont,  ("_"+userNotify), Graphics.TEXT_JUSTIFY_LEFT );
dc.drawText( centerX*1.8, centerY*1, wordFont,  (">"+userAlarm), Graphics.TEXT_JUSTIFY_LEFT );
  dc.drawText(centerX*1.8, centerY*1.17, wordFont, " "+TEMP+" "+FC, Graphics.TEXT_JUSTIFY_RIGHT );
  dc.drawText(centerX, centerY*1.8, wordFont, ("$"+userSTEPS), Graphics.TEXT_JUSTIFY_CENTER );
   
/*
calories exclaim
#charge
$foot
>alarm
*battery
^heart
_new message
+phone
= large alarmring
*/

}



    function onHide() as Void { }

    
    function onExitSleep() as Void {}

    
    function onEnterSleep() as Void {}

function weather(cond) {
  if (cond == 0 || cond == 40){return "b";}//sun
  else if (cond == 50 || cond == 49 ||cond == 47||cond == 45||cond == 44||cond == 42||cond == 31||cond == 27||cond == 26||cond == 25||cond == 24||cond == 21||cond == 18||cond == 15||cond == 14||cond == 13||cond == 11||cond == 3){return "a";}//rain
  else if (cond == 52||cond == 20||cond == 2||cond == 1){return "e";}//cloud
  else if (cond == 5 || cond == 8|| cond == 9|| cond == 29|| cond == 30|| cond == 33|| cond == 35|| cond == 37|| cond == 38|| cond == 39){return "g";}//wind
  else if (cond == 51 || cond == 48|| cond == 46|| cond == 43|| cond == 10|| cond == 4){return "i";}//snow
  else if (cond == 32 || cond == 37|| cond == 41|| cond == 42){return "f";}//whirlwind 
  else {return "c";}//suncloudrain 
}


private function getHeartRate() {
  // initialize it to null
  var heartRate = null;

  // Get the activity info if possible
  var info = Activity.getActivityInfo();
  if (info != null) {
    heartRate = info.currentHeartRate;
  } else {
    // Fallback to `getHeartRateHistory`
    var latestHeartRateSample = ActivityMonitor.getHeartRateHistory(1, true).next();
    if (latestHeartRateSample != null) {
      heartRate = latestHeartRateSample.heartRate;
    }
  }

  // Could still be null if the device doesn't support it
  return heartRate;
}


function dogPhase(stepgoal){
  var mySettingsHeight = System.getDeviceSettings().screenHeight;
  // if (mySettings.screenShape != 1)
  var dogARRAY;

if (mySettingsHeight == 218){
 dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow218,
            :locX=>0,
            :locY=>0
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow2181,
            :locX=> 0,
            :locY=>0
        })),
                (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow2182,
            :locX=> 0,
            :locY=>0
        }))
 ];
}else if (mySettingsHeight == 260){
 dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow260,
            :locX=> 0,
            :locY=>0
        })),
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow2601,
            :locX=> 0,
            :locY=>0
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow2602,
            :locX=> 0,
            :locY=>0
        }))
 ];
}
else if (mySettingsHeight == 360){
 dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow360,
            :locX=> 0,
            :locY=>0
        })),
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow3601,
            :locX=> 0,
            :locY=>0
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow3602,
            :locX=> 0,
            :locY=>0
        }))
 ];
}else if (mySettingsHeight == 390){
 dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow390,
            :locX=> 0,
            :locY=>0
        })),
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow3901,
            :locX=> 0,
            :locY=>0
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow3902,
            :locX=> 0,
            :locY=>0
        }))
 ];
}else if (mySettingsHeight == 416){
 dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow416,
            :locX=> 0,
            :locY=>0
        })),
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow4161,
            :locX=> 0,
            :locY=>0
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow4162,
            :locX=> 0,
            :locY=>0
        }))
 ];
}else if (mySettingsHeight == 454){
 dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow454,
            :locX=> 0,
            :locY=>0
        })),
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow4541,
            :locX=> 0,
            :locY=>0
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow4542,
            :locX=> 0,
            :locY=>0
        }))
 ];
}else{
  dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow218,
            :locX=> 0,
            :locY=>0
        })),
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow2181,
            :locX=> 0,
            :locY=>0
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.grow2182,
            :locX=> 0,
            :locY=>0
        }))
 ];
}
return dogARRAY[stepgoal];
}

function dogPhase2(seconds, stepgoal){
  var mySettingsHeight = System.getDeviceSettings().screenHeight;
  // if (mySettings.screenShape != 1)
  var dogARRAY;
 var growX = 1; //0.75 for grow large 1.25 for shrink small 1 for normal or square
var growY = 1;
var size = 0;
//var speed =1;     
      if (mySettingsHeight == 218){
        size =1;
        growX=0.79;
        //speed = 0.6;
        growY=0.7;
      } else if (mySettingsHeight == 260){
        size =1;
        growX=1.4;
        //speed = 0.6;
        growY=1.5;
      }else if (mySettingsHeight > 360 && System.getDeviceSettings().screenHeight < 415){
        size=2;
        growX=0.7;
        //speed = 1.25;
        growY=0.1;
      }else if (mySettingsHeight == 416){
        size=2;
        growX=0.8;
        //speed = 1.25;
        growY=0.6;
      }else if (mySettingsHeight == 454){
          size=2;
        growX=0.8;
        //speed = 1.25;
        growY=0.6;
      }else if ( System.getDeviceSettings().screenShape != 1){
        size=0;
        growX=0.85;
        //speed = 0.9;
        growY=0.7;
      }else{
        size=0;
        growX=0.8;
        //speed =1;
        growY=0.7;
      }
      var goaly = 0;
       var goalx = 0;
if (stepgoal == 0){goaly=0.4;goalx=0.5;}
else if (stepgoal == 1){goaly=0.2;goalx=0.5;}
else if (stepgoal == 2){goaly=0.17;goalx=0.45;}
else {goaly=0.5;goalx=0.5;}

  var venus2X =  System.getDeviceSettings().screenWidth *goalx*growX;
 //if (seconds>=35){venus2X=mySettings.screenHeight *0.17*growX;}else {if(seconds>=25){venus2X=(mySettings.screenWidth*2.5)-((seconds%35)*25*speed);}else{venus2X=(mySettings.screenWidth)-((seconds%35)*25*speed);}}
  var venus2Y =   System.getDeviceSettings().screenHeight *goaly*growY ;

if (size == 1){
 dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALL1,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.SMALL2,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
 ];
}
else if (size == 2){     
   dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIG1,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.BIG2,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
 ];      
}
else {
   dogARRAY = [
(new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.MED1,
            :locX=> venus2X,
            :locY=>venus2Y
        })),
        (new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.MED2,
            :locX=> venus2X,
            :locY=>venus2Y
        }))
 ]; 
}
return dogARRAY[seconds%2];
}

}
