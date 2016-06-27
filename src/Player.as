package {

import starling.display.Sprite;

public class Player extends Sprite {

    private var _playerName:String;
    private var _credits:int;

    public function Player() {

    }

    public function setPlayerName(name:String):void {
        _playerName = name;
    }

    public function getPlayerName():String {
        return _playerName;
    }

    public function getCredits():int {
        return _credits;
    }

    public function updateCredits(value:int):void {
        _credits += value;
    }



























}
}
