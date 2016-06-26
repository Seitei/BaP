package gameLogic {
import entities.Entity;
import entities.Spawner;

import flash.geom.Point;

import net.NetConnect;

import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import ui.HudLayer;

public class GLMyTurn implements IGameLogic{

    private var _game:Game;
    private var _currentEntity:Spawner;
    private var _buildingPath:Boolean;
    private var _stateName:int;

    public function GLMyTurn() {

        _stateName = GameStateMachine.MY_TURN;
        _game = Game.getInstance();

    }

    public function getStateName():int {
        return _stateName;
    }

    public function endTurn():void {

        _game.removeEventListener(TouchEvent.TOUCH, onCreateEntityOnClick);
        _game.removeEventListener(KeyboardEvent.KEY_UP, finishTurn);

    }

    public function startTurn():void {

        _game.addEventListener(TouchEvent.TOUCH, onCreateEntityOnClick);
        _game.addEventListener(KeyboardEvent.KEY_UP, finishTurn);

    }

    private function onCreateEntityOnClick(e:TouchEvent):void {

        if(_buildingPath){
            return;
        }

        var began:Touch = e.getTouch(_game, TouchPhase.BEGAN);

        if(began){

            //TODO integrate with visual UI
            if(began.globalY <= _game.stage.stageHeight / 2){
                return;
            }

            _buildingPath = true;
            //TODO remove this and implement it in the UI
            if(processCost()){

                showPath(Spawner(_game.createEntity("SMT1", _game.getPlayer(), new Point(began.globalX, began.globalY), true)));

            }
        }

    }

    private function processCost():Boolean {
        return true;
    }

    private function showPath(entity:Spawner):void {

        _currentEntity = entity;
        HudLayer.getInstance().beginPath(entity, onPathFinished);

    }

    private function onPathFinished(waypoints:Array):void {

        _buildingPath = false;
        _currentEntity.setWayPoints(waypoints);

        _game.sendMessage({type: NetConnect.UPDATE_ENTITY_DATA, data: {id: _currentEntity.getId(), params: {wayPoints: waypoints}}});

    }


    private function finishTurn(e:KeyboardEvent):void {

        _game.sendMessage({type: "turnEnded", data: {player: _game.getPlayer()}});
        _game.onTurnEnded(_game.getPlayer());

    }


}
}
