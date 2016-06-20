package {

import entities.Entity;
import entities.EntityFactory;

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

public class Game extends Sprite {

    registerClassAlias("point", Point);

    private static const ONLINE:Boolean = true;
    private static var _instance:Game;
    private var _background:Image;
    private var _assets:AssetManager;
    private var _entities:Vector.<Entity>;
    private var _net:NetConnect;
    private var _entitiesSubGroups:Dictionary;
    private var _entitiesByID:Dictionary;
    private var _entitiesLayer:Sprite;
    private var _gsm:GameStateMachine;
    private var _corePlayerOne:Entity;
    private var _corePlayerTwo:Entity;
    private var _player:String;
    private var _entitiesToDestroy:Array;

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

        ResourceManager.addAssetManager(_assets);
        _background = new Image(ResourceManager.getAssetManager().getTexture("background"));
        addChild(_background);

        _entitiesLayer = new Sprite();
        addChild(_entitiesLayer);

        //TODO change this to something more organized
        _entitiesToDestroy = new Array();
        _entities = new <Entity>[];
        _entitiesSubGroups = new Dictionary();
        _entitiesByID = new Dictionary();

        _entitiesSubGroups["playerOne"] = new Vector.<Entity>;
        _entitiesSubGroups["playerTwo"] = new Vector.<Entity>;
        _entitiesSubGroups["shootablePlayerOneEntities"] = new Vector.<Entity>;
        _entitiesSubGroups["shootablePlayerTwoEntities"] = new Vector.<Entity>;

        _net = new NetConnect();

        if (ONLINE) {
            _net.addEventListener("messageReceived", onMessageReceived);
        }
        else {
            //onPlayerFound();
        }

        addChild(HudLayer.getInstance());

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

        }

        _entitiesByID[message.data.id].setParams(message.data.params);

        if(message.data.params.wayPoints){

            HudLayer.getInstance().addPath(_entitiesByID[message.data.id]);
            HudLayer.getInstance().drawPath(message.data.id);

        }

    }

    public function onTurnEnded(player:String):void {

        if(player == "playerOne"){

            if(_player == "playerOne"){
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

        if(_player == "playerOne"){
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

        if(message.data.type == "core"){
            HudLayer.getInstance().setEnemyCorePosition(new Point(reflectedPositionX, reflectedPositionY));
        }

    }

    private function onPlayerFound():void {

        //TODO remove when server is implemented
        MM_ORDER::player_one{

            _player = "playerOne";
            _gsm.goTo(GameStateMachine.MY_TURN);

        }

        MM_ORDER::player_two{

            _player = "playerTwo";
            _gsm.goTo(GameStateMachine.ENEMY_TURN);
        }

        addCore();

    }


    /////////////////////////////////////////////////////////////////////

    private function addCore():void {

        _corePlayerOne = createEntity("core", _player, new Point(stage.stageWidth / 2, stage.stageHeight * 0.9), true);

    }

    public function createEntity(type:String, owner:String, position:Point, send:Boolean, params:Object = null):Entity {

        var entity:Entity = EntityFactory.getInstance().createEntity(type, owner, position, params);
        addEntity(entity, send);

        return entity;

    }


    private function addEntity(entity:Entity, send:Boolean):void {

        _entitiesSubGroups[entity.getOwner()].push(entity);
        _entitiesSubGroups[entity.getOwner()].push(entity);
        _entities.push(entity);
        _entitiesByID[entity.getId()] = entity;

        if(entity.getEntityType() != "bullet"){

            if(entity.getOwner() == "playerOne"){

                _entitiesSubGroups["shootablePlayerOneEntities"].push(entity);

            }

            if(entity.getOwner() == "playerTwo"){

                _entitiesSubGroups["shootablePlayerTwoEntities"].push(entity);

            }
        }

        _entitiesLayer.addChild(entity.getVisual());

        if(send){
            sendMessage({type: NetConnect.ENTITY_ADDED, data: {type: entity.getEntityName(), owner:entity.getOwner(), position:entity.getPosition()}});
        }

    }

    public function getEntityByID(entityID:int):Entity {
        return _entitiesByID[entityID];
    }

    public function getEntitiesSubGroup(subGroup:String):Vector.<Entity> {

        return _entitiesSubGroups[subGroup];

    }

    public function getCore(player:String):Entity {
        return player == "playerOne" ? _corePlayerOne : _corePlayerTwo;
    }


    public function getEntities():Vector.<Entity> {
        return _entities;
    }

    public function getPlayer():String {

        return _player;

    }

    public function getOppositePlayer():String {

        return _player == "playerOne" ? "playerTwo" : "playerOne";

    }

    public function getEntityOppositePlayer(owner:String):String {

        return owner == "playerOne" ? "playerTwo" : "playerOne";

    }


    public function addToDestroy(entity:Entity):void {

        _entitiesToDestroy.push(entity);

    }

    public function destroyEntity(entity:Entity):void {

        _entities.splice(_entities.indexOf(entity), 1);
        delete _entitiesByID[entity.getId()];

    }

    public function checkEntitiesToDestroy():void {

        if(_entitiesToDestroy.length > 0){

            for(var i:int = 0; i < _entitiesToDestroy.length; i++){

                destroyEntity(_entitiesToDestroy[i]);

            }
        }

        _entitiesToDestroy.splice(0);

    }





    public static function getInstance():Game {

        return _instance;

    }

}
}
