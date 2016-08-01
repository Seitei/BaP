package gameLogic {
import entities.Entity;
import entities.EntityManager;

import starling.events.EnterFrameEvent;
import starling.events.Event;

public class GLPlay implements IGameLogic{

    private static const PLAY_TIME_DURATION:int = 7 * 60;

    private var _turnTime:int;
    private var _game:Game;
    private var _entities:Vector.<Entity>;
    private var _stateName:int;

    public function GLPlay() {

        _stateName = GameStateMachine.PLAY_TIME;
        _game = Game.getInstance();
        _entities = EntityManager.getInstance().getEntitites();

    }

    public function getStateName():int {
        return _stateName;
    }

    public function endTurn():void {

        _game.removeEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);

    }

    public function startTurn():void {

        _turnTime = 0;
        _game.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);

    }

    private function onEnterFrame(e:Event):void {

        _turnTime ++;

        for (var i:int = 0; i < _entities.length; i++) {

            _entities[i].update();

        }

        if(_turnTime > PLAY_TIME_DURATION){

            _game.onPlayTimeEnded();

        }

        EntityManager.getInstance().checkEntitiesToDestroy();

    }


}
}
