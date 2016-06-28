package gameLogic {
import entities.Entity;
import entities.IExecuteOnTurnStart;
import entities.ISpawner;
import entities.ISpawner;
import entities.ISpawner;
import entities.ISpawner;
import entities.ISpawner;
import entities.Spawner;

import flash.ui.Keyboard;

import net.NetConnect;

import starling.events.Event;
import starling.events.KeyboardEvent;

import ui.HudLayer;
import ui.Shop;

public class GLMyTurn implements IGameLogic{

    private var _game:Game;
    private var _currentEntity:Entity;
    private var _buildingPath:Boolean;
    private var _stateName:int;
    private var _shop:Shop;
    private var _entities:Vector.<Entity>;

    public function GLMyTurn() {

        _stateName = GameStateMachine.MY_TURN;
        _game = Game.getInstance();
        _shop = Shop.getInstance();
        _shop.addEventListener("entityPlaced", onEntityPlaced);
        _entities = _game.getEntities();

    }



    public function getStateName():int {
        return _stateName;
    }

    public function endTurn():void {

        Shop.getInstance().deactivateShop();
        _game.removeEventListener(KeyboardEvent.KEY_UP, finishTurn);
        HudLayer.getInstance().showTurnAid(false);

    }

    public function startTurn():void {

        Shop.getInstance().activateShop();
        _game.addEventListener(KeyboardEvent.KEY_UP, finishTurn);
        HudLayer.getInstance().showTurnAid(true);
        Game.getInstance().getPlayer().updateCredits(10);
        checkEntitiesProc();

    }

    private function checkEntitiesProc():void {

        for (var i:int = 0; i < _entities.length; i++) {

            if(_entities[i] is IExecuteOnTurnStart){
                IExecuteOnTurnStart(_entities[i]).executeOnTurnStart();
            }

        }
    }

    private function onEntityPlaced(e:Event, data:Object):void {

        var entity:Entity = _game.createEntity(data.entityName, _game.getPlayerName(), data.position, true);

        if(entity is ISpawner){
            showPath(_game.createEntity(data.entityName, _game.getPlayerName(), data.position, true));
        }

    }

    private function showPath(entity:Entity):void {

        _currentEntity = entity;
        HudLayer.getInstance().beginPath(entity, onPathFinished);

    }

    private function onPathFinished(waypoints:Array):void {

        _buildingPath = false;
        ISpawner(_currentEntity).setWayPoints(waypoints);

        _game.sendMessage({type: NetConnect.UPDATE_ENTITY_DATA, data: {id: _currentEntity.getId(), params: {wayPoints: waypoints}}});

    }


    private function finishTurn(e:KeyboardEvent):void {

        if(e.keyCode == Keyboard.SPACE){

            _game.sendMessage({type: "turnEnded", data: {player: _game.getPlayerName()}});
            _game.onTurnEnded(_game.getPlayerName());

        }

    }


}
}
