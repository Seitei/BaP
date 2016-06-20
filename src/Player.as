package {

import starling.display.Sprite;

public class Player extends Sprite {

    private var _player:String;
    private var _credits:int;

    public function Player(player:String) {

        _player = player;
        _credits = 10;

    }

    public function toString():String {
        return _player;
    }


    public function getCredits():int {
        return _credits;
    }

    public function setCredits(value:int):void {
        _credits = value;
    }



























}
}
