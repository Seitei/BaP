package ui {
import entities.EntitiesData;
import entities.Entity;
import entities.EntityFactory;

import flash.geom.Point;
import flash.ui.Keyboard;
import flash.ui.Mouse;

import starling.display.Sprite;
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

    public function Shop() {

        _game = Game.getInstance();
        _helperPoint = new Point();
        Game.getInstance().addEventListener(TouchEvent.TOUCH, onPreTouch);

    }

    private function onKeyUp(e:KeyboardEvent):void {

        if(e.keyCode == Keyboard.ESCAPE){
            cancel();
            return;
        }

        if(_positioning){
            return;
        }

        var entityName:String;

        switch(e.keyCode){

            case Keyboard.Q:
                entityName = EntitiesData.SMT1;
                break;

            case Keyboard.W:
                entityName = EntitiesData.SMT2;
                break;

            case Keyboard.Z:
                entityName = EntitiesData.CB1;
                break;

            case Keyboard.X:
                entityName = EntitiesData.CB2;
                break;

            case Keyboard.A:
                entityName = EntitiesData.TOWERT1;
                break;

            case Keyboard.S:
                entityName = EntitiesData.TOWERT2;
                break;

        }

        if(entityName){
            _entityName = entityName;
            tryEntity(entityName);
        }


    }

    private function cancel():void {

        _positioning = false;
        _entityToPlace.destroy();
        Game.getInstance().removeEventListener(TouchEvent.TOUCH, onTouch);
        Game.getInstance().addEventListener(TouchEvent.TOUCH, onPreTouch);

    }


    private function tryEntity(entityName:String):void {

        if(checkPrice(entityName)){
            Mouse.hide();
            _positioning = true;
            displayEntity(entityName);
        }
        else {
            UIElements.getInstance().showRed();
        }

    }

    private function displayEntity(entityName:String):void {

        MouseUtils.setMouseCursor();
        Game.getInstance().addEventListener(TouchEvent.TOUCH, onTouch);
        _entityToPlace = EntityFactory.getInstance().createEntity(entityName, Game.getInstance().getPlayerName(), null, true);
        _entityToPlace.setPreGraphicsPosition(_helperPoint);
        addChild(_entityToPlace.getPreGraphics());
        Game.getInstance().removeEventListener(TouchEvent.TOUCH, onPreTouch);


    }

    private function checkPrice(entityName:String):Boolean {

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

            Mouse.show();
            _positioning = false;
            _game.getPlayer().updateCredits(-EntitiesData.data[_entityName][EntitiesData.PRICE]);
            dispatchEventWith("entityPlaced", false, {entityName: _entityName, position: _entityToPlace.getPosition()});
            Game.getInstance().removeEventListener(TouchEvent.TOUCH, onTouch);
            deactivateShop();
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
