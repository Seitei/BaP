package ui {
import entities.EntitiesData;
import entities.Entity;
import entities.EntityFactory;

import flash.geom.Point;
import flash.ui.Keyboard;
import flash.ui.Mouse;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.Event;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

import utils.MouseUtils;

public class Shop extends Sprite{

    private static var _instance:Shop;
    private var _game:Game;
    private var _entityToPlace:Entity;
    private var _disabled:Boolean;
    private var _entityName:String;
    private var _positioning:Boolean;
    private var _helperPoint:Point;
    private var _selector:Sprite;
    private var _showingSelector:Boolean;

    public function Shop() {

        _game = Game.getInstance();
        _helperPoint = new Point();
        Game.getInstance().addEventListener(TouchEvent.TOUCH, onPreTouch);
        //addEventListener(Event.ADDED_TO_STAGE, onAdded);


    }

    private function onAdded(event:Event):void {

        buildSelector();

    }

    private function buildSelector():void {

        _selector = new Sprite();

        var array:Array = ["pawn", "knight", "bishop", "rook", "queen"];
        var center:int = stage.stageWidth / 2;

        for (var i:int = 0; i < 5; i++) {

            var image:Image = new Image(ResourceManager.getAssetManager().getTexture(array[i]));
            image.name = array[i];
            image.pivotX = image.pivotY = image.width / 2;

            var posX:int = center + Math.cos(i * (360 / 5) * Math.PI / 180) * stage.stageWidth / 5;
            var posY:int = center + Math.sin(i * (360 / 5) * Math.PI / 180) * stage.stageWidth / 5;

            image.x = posX;
            image.y = posY;

            image.addEventListener(TouchEvent.TOUCH, onPieceTouched);
            _selector.addChild(image);

        }


    }

    private function onPieceTouched(event:TouchEvent):void {

        event.stopImmediatePropagation();
        var began:Touch = event.getTouch(this, TouchPhase.BEGAN);

        if(began){
            onPieceChosen(Image(event.currentTarget).name);
        }

    }


    private function onPieceChosen(pieceName:String):void {

        var entityName:String;


        switch(pieceName){

            case "pawn":
                entityName = EntitiesData.SMT1;
                break;

            case "knight":
                entityName = EntitiesData.SRT1;
                break;

            case "bishop":
                entityName = EntitiesData.SRT2;
                break;

            case "rook":
                entityName = EntitiesData.TOWERT1;
                break;

            case "queen":
                entityName = EntitiesData.TOWERT3;
                break;

        }

        _entityName = entityName;
        hideSelector();
        tryEntity(entityName);


    }


    private function onKeyUp(e:KeyboardEvent):void {

        if(e.keyCode == Keyboard.ESCAPE){
            cancel();
            return;
        }


        /*if(e.keyCode == Keyboard.ENTER){
            if(_showingSelector){
                hideSelector();
            }
            else {
                showSelector();
            }

            return;
        }*/


        var entityName:String;

        switch(e.keyCode){

            case Keyboard.Q:
                entityName = EntitiesData.SMT1;
                break;

            case Keyboard.A:
                entityName = EntitiesData.SMT2;
                break;

            case Keyboard.Z:
                entityName = EntitiesData.SMT3;
                break;

            case Keyboard.W:
                entityName = EntitiesData.SRT1;
                break;

            case Keyboard.S:
                entityName = EntitiesData.SRT2;
                break;

            case Keyboard.X:
                entityName = EntitiesData.SRT3;
                break;

            case Keyboard.E:
                entityName = EntitiesData.TOWERT1;
                break;

            case Keyboard.D:
                entityName = EntitiesData.TOWERT2;
                break;

            case Keyboard.C:
                entityName = EntitiesData.TOWERT3;
                break;

            case Keyboard.R:
                entityName = EntitiesData.CB1;
                break;

            case Keyboard.F:
                entityName = EntitiesData.CB2;
                break;

            case Keyboard.T:
                entityName = EntitiesData.ROCKT1;
                break;

            case Keyboard.G:
                entityName = EntitiesData.ROCKT2;
                break;



        }

        if(entityName){
            if(_positioning){
                cancel();
            }
            _entityName = entityName;
            tryEntity(entityName);
        }


    }

    private function showSelector():void {
        _showingSelector = true;
        addChild(_selector);
        _game.blur(true);
    }

    private function hideSelector():void {
        _showingSelector = false;
        removeChild(_selector);
        _game.blur(false);
    }

    private function cancel():void {

        MouseUtils.reset();
        _positioning = false;
        _entityToPlace.destroy();
        Game.getInstance().removeEventListener(TouchEvent.TOUCH, onTouch);
        Game.getInstance().addEventListener(TouchEvent.TOUCH, onPreTouch);

    }


    private function tryEntity(entityName:String):void {

        if(checkPrice(entityName)){
            _positioning = true;
            displayEntity(entityName);
        }
        else {
            UIElements.getInstance().showRed();
        }

    }

    private function displayEntity(entityName:String):void {

        Mouse.hide();
        Game.getInstance().addEventListener(TouchEvent.TOUCH, onTouch);
        _entityToPlace = EntityFactory.getInstance().createEntity(entityName, Game.getInstance().getPlayerName(), null, true);
        _entityToPlace.setPreGraphicsPosition(_helperPoint);
        addChild(_entityToPlace.getPreGraphics());
        Game.getInstance().removeEventListener(TouchEvent.TOUCH, onPreTouch);


    }

    private function checkPrice(entityName:String):Boolean {

        return true;
        return _game.getPlayer().getCredits() >= EntitiesData.data[entityName][EntitiesData.PRICE];

    }

    private function onPreTouch(e:TouchEvent):void {

        var hover:Touch = e.getTouch(_game, TouchPhase.HOVER);

        if(hover){

            _helperPoint.x = hover.globalX;
            _helperPoint.y = hover.globalY;

        }

    }

    private function onTouch(e:TouchEvent):void {

        var began:Touch = e.getTouch(_game, TouchPhase.BEGAN);
        var hover:Touch = e.getTouch(_game, TouchPhase.HOVER);

        if(hover){

            _helperPoint.x = hover.globalX;
            _helperPoint.y = hover.globalY;
            _entityToPlace.setPreGraphicsPosition(_helperPoint);

            if(!_disabled && !checkPosition(hover.globalX, hover.globalY)){
                disablePlacing();
            }

            if(_disabled && checkPosition(hover.globalX, hover.globalY)){
                enablePlacing();
            }

        }

        if(began){

            if(_disabled){
                return;
            }

            deactivateShop();
            Mouse.show();
            _positioning = false;
            _game.getPlayer().updateCredits(-EntitiesData.data[_entityName][EntitiesData.PRICE]);
            dispatchEventWith("entityPlaced", false, {entityName: _entityName, position: _entityToPlace.getPosition()});
            Game.getInstance().removeEventListener(TouchEvent.TOUCH, onTouch);
            Game.getInstance().addEventListener(TouchEvent.TOUCH, onPreTouch);

            _entityToPlace.destroy();

        }


    }

    private function disablePlacing():void {

        _disabled = true;
        _entityToPlace.getVisual().disablePreGraphics();

    }

    private function enablePlacing():void {

        _disabled = false;
        _entityToPlace.getVisual().enablePreGraphics();

    }

    private function checkPosition(posX:Number, posY:Number):Boolean {

        return posY >= _game.stage.stageHeight / 2;

    }

    public function activateShop():void {

        _game.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

    }

    public function deactivateShop():void {

        _game.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);

    }

    public static function getInstance():Shop {

        if(!_instance){
            _instance = new Shop();
        }
        return _instance;
    }
}
}
