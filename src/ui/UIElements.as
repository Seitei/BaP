package ui {
import flash.events.TimerEvent;
import flash.utils.Timer;

import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

public class UIElements extends Sprite{

    private static var _instance:UIElements;
    private var _game:Game;
    private var _creditsTxt:TextField;
    private var _credits:Number = 0;
    private var _timer:Timer;

    public function UIElements() {

        _game = Game.getInstance();
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(event:Event):void {
        initElements();
    }

    private function initElements():void {

        _creditsTxt = new TextField(100, 35, "");
        _creditsTxt.color = Color.WHITE;
        _creditsTxt.y = stage.stageHeight - _creditsTxt.height;
        addChild(_creditsTxt);

    }

    public function updateCredits(value:Number):void {
        _credits += value;
        _creditsTxt.text = _credits.toString();
    }

    public function showRed():void {

        _creditsTxt.color = Color.RED;
        _timer = new Timer(1000, 1);
        _timer.addEventListener(TimerEvent.TIMER, onTimer);
        _timer.start();

    }

    private function onTimer(event:TimerEvent):void {

        _timer.stop();
        _timer.removeEventListener(TimerEvent.TIMER, onTimer);
        _creditsTxt.color = Color.WHITE;

    }


    public static function getInstance():UIElements {

        if(!_instance){
            _instance = new UIElements();
        }

        return _instance;

    }

}
}
