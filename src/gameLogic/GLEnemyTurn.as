package gameLogic {

public class GLEnemyTurn implements IGameLogic{

    private var _stateName:int;

    public function GLEnemyTurn() {

        _stateName = GameStateMachine.ENEMY_TURN;

    }

    public function getStateName():int {
        return _stateName;
    }

    public function startTurn():void {


    }


    public function endTurn():void {

    }


}
}
