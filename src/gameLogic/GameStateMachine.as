package gameLogic {
import flash.utils.Dictionary;

public class GameStateMachine {

    private var _states:Dictionary;
    private var _currentState:int;

    public static var MY_TURN:int = 1;
    public static var ENEMY_TURN:int = 2;
    public static var PLAY_TIME:int = 3;


    public function GameStateMachine() {

        _states = new Dictionary();

        _currentState = 0;

    }

    public function addState(stateClass:Class):void {

        var state:IGameLogic = new stateClass();
        _states[state.getStateName()] = state;

    }

    private function execute():void{

        _states[_currentState].startTurn();

    }

    public function goTo(state:int):void {

        if(_currentState){
            _states[_currentState].endTurn();
        }

        _currentState = state;
        execute();

    }





}
}
