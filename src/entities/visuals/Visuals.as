package entities.visuals {
import entities.*;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Shape;
import starling.display.Sprite;
import starling.display.Sprite;
import starling.display.Sprite;
import starling.display.graphics.NGon;
import starling.utils.Color;

public class Visuals implements IVisuals{

    protected var _entityName:String;
    protected var _entityShape:Image;
    protected var _graphics:DisplayObject;
    protected var _preGraphics:DisplayObject;
    protected var _entity:Entity;


    public function Visuals() {

    }

    //override this to change entity's visual behavior
    public function build(entity:Entity):void {

        _entity = entity;
        //graphics
        _entityName = entity.getEntityName();
        _graphics = new Sprite();

        _entityShape = new Image(ResourceManager.getAssetManager().getTexture(_entityName));
        Sprite(_graphics).addChild(_entityShape);

        _graphics.pivotX = _graphics.width / 2;
        _graphics.pivotY = _graphics.height / 2;

        _preGraphics = new Image(_entityShape.texture);
        _preGraphics.pivotX = _preGraphics.pivotY = _preGraphics.width / 2;
        _preGraphics.alpha = 0.5;

    }

    public function getSize():Number {
        return _graphics.width;
    }

    public function getGraphics():DisplayObject{
        return _graphics;
    }

    public function setSide(owner:String):void {

        if(owner != Game.getInstance().getPlayerName()){
            setColor(ResourceManager.RED);
        }
        else {
            setColor(ResourceManager.GREEN);
        }

    }

    public function getPreGraphics():DisplayObject {
        return _preGraphics;
    }

    public function enablePreGraphics():void {
        _preGraphics.alpha = 0.5;
    }

    public function disablePreGraphics():void {
        _preGraphics.alpha = 0.2;
    }

    protected function setColor(color:uint):void {
        _entityShape.color = color;
    }

    public function debug(value:Boolean):void {
        if(value){
            //setColor(Color.AQUA);

            var center:Quad = new Quad(3, 3, Color.AQUA);
            center.x = center.y = _graphics.width / 2;
            Sprite(_graphics).addChild(center);

            var circle:NGon = new NGon(_graphics.width * 0.5, 100, _graphics.width * 0.45);
            circle.x = circle.y = _graphics.width / 2;
            circle.color = Color.AQUA;
            Sprite(_graphics).addChild(circle);

        }
        else{
            setSide(_entity.getOwner());
        }
    }

    public function destroy():void {
        if(_graphics.parent){
            _graphics.parent.removeChild(_graphics);
        }
        if(_preGraphics.parent){
            _preGraphics.parent.removeChild(_preGraphics);
        }
    }

    public function updateGraphics():void {
        _graphics.x = _entity.getPosition().x;
        _graphics.y = _entity.getPosition().y;
    }








}

}
