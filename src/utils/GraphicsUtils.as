package utils {
import flash.events.TimerEvent;
import flash.utils.Timer;

import starling.display.DisplayObject;
import starling.filters.ColorMatrixFilter;

public class GraphicsUtils {


    //TODO create robust timer class
    public static function setBrightness(time:Number, dO:DisplayObject) {


        var timer:Timer = new Timer(200, 1);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
        timer.start();

        dO.filter = new ColorMatrixFilter().adjustBrightness(1);

    }

    private static function onTimer(event:TimerEvent):void {

    }
}
}
