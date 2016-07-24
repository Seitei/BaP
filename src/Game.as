package {

import entities.EntitiesData;
import entities.Entity;
import entities.EntityFactory;
import entities.EntityManager;
import entities.ISpawner;
import entities.Spawner;

import flash.filesystem.File;
import flash.geom.Point;
import flash.net.registerClassAlias;
import flash.utils.Dictionary;

import gameLogic.GLEnemyTurn;
import gameLogic.GLMyTurn;
import gameLogic.GLPlay;
import gameLogic.GameStateMachine;

import net.NetConnect;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;

import ui.HudLayer;
import ui.Shop;
import ui.UIElements;

public class Game extends Sprite {

    registerClassAlias("point", Point);

    private static const ONLINE:Boolean = true;
    private static var _instance:Game;
    private var _background:Image;
    private var _assets:AssetManager;
    private var _net:NetConnect;
    private var _entitiesLayer:Sprite;
    private var _gsm:GameStateMachine;
    private var _corePlayerOne:Entity;
    private var _corePlayerTwo:Entity;
    private var _player:Player;
    private var _hudLayer:HudLayer;
    private var _shop:Shop;
    private var _uiElements:UIElements;
    private var _entities:EntityManager;

    public function Game() {

        _instance = this;
        addEventListener(Event.ADDED_TO_STAGE, onAdded);

    }

    private function onAdded(e:Event):void {

        loadAssets();

    }


    private function loadAssets():void {

        var appDir:File = File.applicationDirectory;
        _assets = new AssetManager();

        _assets.enqueue(
                appDir.resolvePath("assets/")
        );

        _assets.loadQueue(function (ratio:Number):void {
            if (ratio == 1) {

                init();
            }
        });
    }


    private function init():void {

        _entities = EntityManager.getInstance();
        ResourceManager.addAssetManager(_assets);
        _background = new Image(ResourceManager.getAssetManager().getTexture("background"));
        addChild(_background);

        _entitiesLayer = new Sprite();
        addChild(_entitiesLayer);

        _player = new Player();

        _net = new NetConnect();

        if (ONLINE) {
            _net.addEventListener("messageReceived", onMessageReceived);
        }
        else {
            //onPlayerFound();
        }

        _hudLayer = HudLayer.getInstance();
        addChild(_hudLayer);

        _shop = Shop.getInstance();
        addChild(_shop);

        _uiElements = UIElements.getInstance();
        addChild(_uiElements);

        initStateMachine();

    }

    private function initStateMachine():void {

        _gsm = new GameStateMachine();

        _gsm.addState(GLMyTurn);
        _gsm.addState(GLEnemyTurn);
        _gsm.addState(GLPlay);
    }

    /////////////////////// NET CONNECT MESSAGING ///////////////////////

    private function onMessageReceived(e:Event, message:Object):void {

        switch(message.type){
            case NetConnect.PLAYER_FOUND:
                onPlayerFound();
                break;
            case NetConnect.ENTITY_ADDED:
                onEntityAdded(message);
                break;
            case NetConnect.UPDATE_ENTITY_DATA:
                updateEntityData(message);
                break;
            case NetConnect.TURN_ENDED:
                onTurnEnded(message.data.player);
                break;
        }

    }

    public function sendMessage(message:Object):void {

        _net.sendMessage(message.type, message.data);

    }

    private function updateEntityData(message:Object):void {

        if(message.data.params.wayPoints){

            var invertedArray:Array = new Array();
            var originalArray:Array = message.data.params.wayPoints;

            for(var i:int = 0; i < originalArray.length; i++){

                invertedArray.push(new Point);
                invertedArray[i].x = stage.stageWidth - originalArray[i].x;
                invertedArray[i].y = stage.stageHeight - originalArray[i].y;

            }

            message.data.params.wayPoints = invertedArray;
            _entities.updateEntityByID(message.data.id, "setWayPoints", invertedArray);

            HudLayer.getInstance().addPath(Spawner(_entities.getEntityByID(message.data.id)));
            HudLayer.getInstance().drawPath(message.data.id);

        }


    }

    public function onTurnEnded(player:String):void {

        if(player == "playerOne"){

            if(_player.getPlayerName() == "playerOne"){
                _gsm.goTo(GameStateMachine.ENEMY_TURN);
            }
            else {
                _gsm.goTo(GameStateMachine.MY_TURN);
            }

        }

        if(player == "playerTwo"){
            _gsm.goTo(GameStateMachine.PLAY_TIME);
        }
    }

    public function onPlayTimeEnded():void {

        if(_player.getPlayerName() == "playerOne"){
            _gsm.goTo(GameStateMachine.MY_TURN);
        }
        else {
            _gsm.goTo(GameStateMachine.ENEMY_TURN);
        }

    }


    private function onEntityAdded(message:Object):void {

        var reflectedPositionX:int = stage.stageWidth - message.data.position.x;
        var reflectedPositionY:int = stage.stageHeight - message.data.position.y;

        createEntity(message.data.type, message.data.owner, new Point(reflectedPositionX, reflectedPositionY), false);

        if(message.data.type == EntitiesData.CORE){
            HudLayer.getInstance().setEnemyCorePosition(new Point(reflectedPositionX, reflectedPositionY));
        }

    }

    private function onPlayerFound():void {

        // TODO get player number from player instance
        if(_net.getPlayerNumber() == 1){

            _player.setPlayerName("playerOne");
            _gsm.goTo(GameStateMachine.MY_TURN);

        } else {
            _player.setPlayerName("playerTwo");
            _gsm.goTo(GameStateMachine.ENEMY_TURN);
        }

        addCore();
    }


    /////////////////////////////////////////////////////////////////////

    private function addCore():void {

        _corePlayerOne = createEntity(EntitiesData.CORE, _player.getPlayerName(), new Point(stage.stageWidth / 2, stage.stageHeight * 0.9), true);

    }

    public function createEntity(type:String, owner:String, position:Point, send:Boolean):Entity {

        var entity:Entity = EntityFactory.getInstance().createEntity(type, owner, position);
        addEntity(entity, send);

        return entity;

    }


    private function addEntity(entity:Entity, send:Boolean):void {

        _entities.addEntity(entity);

        _entitiesLayer.addChild(entity.getGraphics());

        if(send){
            sendMessage({type: NetConnect.ENTITY_ADDED, data: {type: entity.getEntityName(), owner:entity.getOwner(), position:entity.getPosition()}});
        }

    }

    public function getEntitiesLayer():Sprite {
        return _entitiesLayer;
    }

    public function getPlayerName():String {

        return _player.getPlayerName();

    }

    public function getOppositePlayerName():String {
        return _player.getPlayerName() == "playerOne" ? "playerTwo" : "playerOne";
    }


    public function getPlayer():Player {
        return _player;
    }



    public static function getInstance():Game {

        return _instance;

    }

}
}
