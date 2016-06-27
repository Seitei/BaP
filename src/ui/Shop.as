package ui {
import entities.EntitiesData;

import flash.geom.Point;
import flash.ui.Keyboard;

import starling.display.Image;

import starling.display.Sprite;

import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;
import starling.utils.Color;

public class Shop extends Sprite{

    private static var _instance:Shop;
    private var _game:Game;
    private var _entityToPlace:Image;
    private var _disabled:Boolean;
    private var _entityName:String;

    public function Shop() {

        _game = Game.getInstance();
        _entityToPlace = new Image(Texture.empty(50, 50));
        addChild(_entityToPlace);
        _entityToPlace.alpha = 0.5;
        _entityToPlace.visible = false;

    }

    private function onKeyUp(e:KeyboardEvent):void {

        var entityName:String;

        switch(e.keyCode){

            case Keyboard.Q:
                entityName = "SMT1";
                break;

            case Keyboard.W:
                entityName = "SMT2";
                break;

        }

        if(entityName){

            _entityName = entityName;
            tryEntity(entityName)

        }

    }


    private function tryEntity(entityName:String):void {

        if(checkPrice(entityName)){
            displayEntity(entityName);
        }

    }

    private function displayEntity(entityName:String):void {

        _entityToPlace.texture = ResourceManager.getAssetManager().getTexture(entityName);
        _entityToPlace.visible = true;
        _entityToPlace.color = Color.GREEN;
        _entityToPlace.readjustSize();
        _entityToPlace.pivotX = _entityToPlace.width / 2;
        _entityToPlace.pivotY = _entityToPlace.height / 2;

        Game.getInstance().addEventListener(TouchEvent.TOUCH, onTouch);

    }

    private function checkPrice(entityName:String):Boolean {

        return _game.getPlayer().getCredits() >= EntitiesData.data[entityName][EntitiesData.PRICE];

    }

    private function onTouch(e:TouchEvent):void {

        var began:Touch = e.getTouch(_game, TouchPhase.BEGAN);
        var hover:Touch = e.getTouch(_game, TouchPhase.HOVER);

        if(hover){

            _entityToPlace.x = hover.globalX;
            _entityToPlace.y = hover.globalY;

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

            _entityToPlace.visible = false;
            _game.getPlayer().updateCredits(-EntitiesData.data[_entityName][EntitiesData.PRICE]);
            dispatchEventWith("entityPlaced", false, {entityName: _entityName, position: new Point(_entityToPlace.x, _entityToPlace.y)});
            Game.getInstance().removeEventListener(TouchEvent.TOUCH, onTouch);
        }


    }

    private function disablePlacing():void {

        _disabled = true;
        _entityToPlace.alpha = 0.2;

    }

    private function enablePlacing():void {

        _disabled = false;
        _entityToPlace.alpha = 0.5;

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
