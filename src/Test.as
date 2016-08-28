package {
import flash.events.TimerEvent;
import flash.utils.Timer;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.Color;

public class Test extends Sprite {

    private var _shipOne:Quad;
    private var _shipTwo:Quad;
    private var _bullet:Quad;
    private var _positionIncrement:Object;
    private var _counter:int;

    private var _quad1:Quad;
    private var _quad2:Quad;

    private static var SHIP_ONE_SPEED_X:Number = 0.5;
    private static var SHIP_ONE_SPEED_Y:Number = 0;
    private static var BULLET_SPEED:Number = 1;


    public function Test() {

        addEventListener(Event.ADDED_TO_STAGE, onAdded);

        var dummy:Quad = new Quad(700, 700);
        addChild(dummy);
        dummy.alpha = 0;

        var timer:Timer = new Timer(2000, 1);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
        timer.start();


    }

    private function onTimer(event:TimerEvent):void {

        addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);


        _quad1 = new Quad(50, 50, Color.AQUA);
        _quad1.y = 100;
        addChild(_quad1);

        _quad2 = new Quad(50, 50, Color.AQUA);
        _quad2.y = 200;
        addChild(_quad2);

        var tween:Tween = new Tween(_quad1, 1, Transitions.LINEAR);
        tween.animate("x", 100);
        tween.onUpdate = onUpdate;
        Starling.juggler.add(tween);

    }

    private function onUpdate(args:Quad):void {
        trace(args.x);
    }


    private function onEnterFrame(event:EnterFrameEvent):void {

        _counter = _quad1.x;

        if(_counter <= 60){
            _quad2.x += 100/60;
            trace(_quad1.x - _quad2.x);
        }

    }


    private function onAdded(event:Event):void {



        return;








        _shipOne = new Quad(10, 10, Color.AQUA);
        _shipOne.x = stage.stageWidth / 2;
        _shipOne.y = stage.stageHeight / 4;
        addChild(_shipOne);

        _positionIncrement = new Object();
        _positionIncrement.x = 0;
        _positionIncrement.y = 0;

        addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);
        addEventListener(TouchEvent.TOUCH, onTouch);

    }





    private function onTouch(event:TouchEvent):void {

        var began:Touch = event.getTouch(this, TouchPhase.BEGAN);

        if(began){
            //shoot();
            tween();

        }
    }

    private function tween():void {

        var tween:Tween = new Tween(_positionIncrement, 0, Transitions.LINEAR);
        tween.animate("x", SHIP_ONE_SPEED_X);
        Starling.juggler.add(tween);
        _counter = 0;

    }


    private function shoot():void {

        _bullet = new Quad(10, 10, Color.AQUA);
        _bullet.x = _shipTwo.x;
        _bullet.y = _shipTwo.y;
        addChild(_bullet);

        var segmentX:Number = _shipOne.x - _shipTwo.x;
        var segmentY:Number = _shipOne.y - _shipTwo.y;

        var distance:Number = Math.sqrt((segmentX * segmentX) + ( segmentY * segmentY));

        var time:Number = distance / (BULLET_SPEED * 60);

        var tweenX:Tween = new Tween(_bullet, time, Transitions.EASE_OUT_BACK);
        tweenX.animate("x", _shipOne.x + time * SHIP_ONE_SPEED_X * 60 );

        var tweenY:Tween = new Tween(_bullet, time, Transitions.LINEAR);
        tweenY.animate("y", _shipOne.y + time * SHIP_ONE_SPEED_Y * 60);


        Starling.juggler.add(tweenX);
        Starling.juggler.add(tweenY);

    }
































}
}
