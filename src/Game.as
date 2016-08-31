package {

import entities.EntitiesData;
import entities.Entity;
import entities.EntityFactory;
import entities.EntityManager;
import entities.Spawner;

import flash.filesystem.File;
import flash.geom.Point;
import flash.net.registerClassAlias;
import flash.ui.Keyboard;

import gameLogic.GLEnemyTurn;
import gameLogic.GLMyTurn;
import gameLogic.GLPlay;
import gameLogic.GameStateMachine;

import net.NetConnect;

import starling.animation.Juggler;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.filters.BlurFilter;
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
    private var _core:Entity;
    private var _player:Player;
    private var _hudLayer:HudLayer;
    private var _shop:Shop;
    private var _uiElements:UIElements;
    private var _entities:EntityManager;
    private var _debugging:Boolean = true;
    private var _juggler:Juggler;


    public function Game() {

        _instance = this;
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
        _juggler = new Juggler();

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
        ResourceManager.loadSWFData();
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

        if(_debugging){
            addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownDebugging);
        }

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

            case NetConnect.DEBUG:
                receiveDebugData(message.data);
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
                invertedArray[i] = invertCoordinates(originalArray[i]);

            }

            message.data.params.wayPoints = invertedArray;
            _entities.updateEntityByID(message.data.id, "setWayPoints", invertedArray);

            HudLayer.getInstance().addPath(Spawner(_entities.getEntityByID(message.data.id)));
            HudLayer.getInstance().drawPath(message.data.id);

        }


    }

    private function invertCoordinates(point:Point):Point {

        point.x = stage.stageWidth - point.x;
        point.y = stage.stageWidth - point.y;
        return point;
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

    public function blur(value:Boolean):void {

        var filter:BlurFilter = new BlurFilter();

        _background.filter = value ? filter : null;

        _entitiesLayer.filter = value ? filter : null;


    }


    private function onEntityAdded(message:Object):void {

        createEntity(message.data.type, message.data.owner, invertCoordinates(message.data.position), false);

        if(message.data.type == EntitiesData.CORE){
            if(!_core){
                addCore();
            }
            HudLayer.getInstance().setEnemyCorePosition(message.data.position);
        }

    }

    private function onPlayerFound():void {

        // TODO get player number from player instance
        if(_net.getPlayerNumber() == 1){

            _player.setPlayerName("playerOne");
            _gsm.goTo(GameStateMachine.MY_TURN);
            addCore();

        } else {
            _player.setPlayerName("playerTwo");
            _gsm.goTo(GameStateMachine.ENEMY_TURN);
        }

    }


    /////////////////////////////////////////////////////////////////////

    private function addCore():void {

        _core = createEntity(EntitiesData.CORE, _player.getPlayerName(), new Point(stage.stageWidth / 2, stage.stageHeight * 0.9), true);

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


    ///////////////////////////////////// DEBUG /////////////////////////////////////


    public function onKeyDownDebugging(e:KeyboardEvent):void {

        if(e.keyCode == Keyboard.CONTROL){
            sendMessage({type: "debug", data: compileDebugData()});
        }
    }

    public function receiveDebugData(data:Array):void {

        var myData:Array = compileDebugData();

        //compare length
        if(data.length != myData.length){
            trace("Error: amount of units differ!");
        }

        var state:String = "all good!";
        var precision:Number = 0.0001;

        for(var i:int = 0; i < data.length; i++) {

            if(data[i].id == myData[i].id){

                if(data[i].entityName == myData[i].entityName && data[i].position.subtract(invertCoordinates(myData[i].position)).length < precision){

                    //all good

                }
                else {

                    state = "went to shit";

                    if(data[i].entityName != myData[i].entityName){
                       trace("different Name: ", data[i].entityName, "  ", myData[i].entityName);
                   }

                   if(data[i].position.subtract(myData[i].position).length > precision){
                       trace("different position: ", "entityName: ", data[i].entityName, "  ", myData[i].entityName, data[i].position, "  ", myData[i].position);

                   }

                }


            }

        }

        trace(state);

    }

    public function compileDebugData():Array {

        var data:Array = new Array();

        for (var i:int = 0; i < _entities.getEntitites().length; i++) {

            var object:Object = new Object();

            object.id = _entities.getEntitites()[i].getId();
            object.position = _entities.getEntitites()[i].getPosition();
            object.entityName = _entities.getEntitites()[i].getEntityName();

            data.push(object);


        }

        return data;

    }

    //////////////////////////////////////////////////////////////////////////////////





    public static function getInstance():Game {

        return _instance;

    }

    public function getJuggler():Juggler {
        return _juggler;
    }

}
}
