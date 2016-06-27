package gameLogic {
import entities.Spawner;

import flash.ui.Keyboard;

import net.NetConnect;

import starling.events.Event;
import starling.events.KeyboardEvent;

import ui.HudLayer;
import ui.Shop;

public class GLMyTurn implements IGameLogic{

    private var _game:Game;
    private var _currentEntity:Spawner;
    private var _buildingPath:Boolean;
    private var _stateName:int;
    private var _shop:Shop;

    public function GLMyTurn() {

        _stateName = GameStateMachine.MY_TURN;
        _game = Game.getInstance();
        _shop = Shop.getInstance();
        _shop.addEventListener("entityPlaced", onEntityPlaced);

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

    }

    private function onEntityPlaced(e:Event, data:Object):void {

        showPath(Spawner(_game.createEntity(data.entityName, _game.getPlayerName(), data.position, true)));

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

        if(e.keyCode == Keyboard.SPACE){

            _game.sendMessage({type: "turnEnded", data: {player: _game.getPlayerName()}});
            _game.onTurnEnded(_game.getPlayerName());

        }

    }


}
}
