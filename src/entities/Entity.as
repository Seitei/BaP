package entities {

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.utils.Color;

public class Entity{

    private static const GREEN:uint = 0x0DFF00;
    protected var _id:int;
    protected var _entityType:String;
    protected var _visual:DisplayObject;
    protected var _entityName:String;
    protected var _owner:String;
    protected var _posX:Number;
    protected var _posY:Number;
    protected var _destroyed:Boolean;
    protected var _hitPoints:Number;
    protected var _entitySize:Number;

    public function Entity(id:int, entityType:String, entityName:String) {

        _id = id;
        _entityType = entityType;
        _entityName = entityName;

        _visual = new Image(ResourceManager.getAssetManager().getTexture(entityName));
        _visual.scaleX = _visual.scaleY = EntitiesData.ENTITIES_SCALE;
        _visual.pivotX = _visual.width / 2;
        _visual.pivotY = _visual.height / 2;

        _entitySize = _visual.width;

    }

    public function getEntityType():String {
        return _entityType;
    }

    public function getId():int {
        return _id;
    }

    public function update():void {}

    public function getVisual():DisplayObject {
        return _visual;
    }

    public function setPosition(position:Point):void {
        _posX = position.x;
        _posY = position.y;
        updateVisuals();
    }

    protected function updateVisuals():void {
        _visual.x = _posX;
        _visual.y = _posY;
    }

    public function setOwner(owner:String):void {

        _owner = owner;
        Image(_visual).color = _owner == Game.getInstance().getPlayerName() ? GREEN : Color.RED;

        if(_owner != Game.getInstance().getPlayerName()){
            _visual.rotation = Math.PI;
        }
    }

    public function getOwner():String {
        return _owner;
    }

    public function getPosition():Point {
        return new Point(_posX, _posY);
    }

    public function getEntityName():String {
        return _entityName;
    }

    public function updateHP(value:Number):void {

        if(_destroyed){
            return;
        }
        _hitPoints += value;
        if(_hitPoints <= 0){
            destroy();
        }

    }

    public function isDestroyed():Boolean {
        return _destroyed;
    }

    public function destroy():void {

        _destroyed = true;
        Game.getInstance().addToDestroy(this);
        _visual.parent.removeChild(_visual);

    }

    public function debugVisuals(color:uint):void {

        Image(_visual).color = color;

    }

    public function get entitySize():Number {
        return _entitySize;
    }
















}
}
