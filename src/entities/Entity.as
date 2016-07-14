package entities {

import flash.geom.Point;

import starling.display.DisplayObject;

public class Entity{

    private static const GREEN:uint = 0x0DFF00;
    protected var _id:int = -1;
    protected var _entityType:String;
    protected var _visual:IVisuals;
    protected var _entityName:String;
    protected var _owner:String;
    protected var _posX:Number;
    protected var _posY:Number;
    protected var _destroyed:Boolean;
    protected var _hitPoints:Number;
    protected var _entitySize:Number;
    protected var _graphics:DisplayObject;
    protected var _preGraphics:DisplayObject;

    public function Entity(id:int, entityType:String, entityName:String) {

        _id = id;
        _entityType = entityType;
        _entityName = entityName;

    }

    public function buildVisuals(visuals:IVisuals):void {
        _visual = visuals;
        _visual.build(this);
        _graphics = _visual.getGraphics();
        _preGraphics = _visual.getPreGraphics();
        _entitySize = _visual.getSize();
    }

    public function getEntityType():String {
        return _entityType;
    }

    public function getId():int {
        return _id;
    }

    public function update():void {}

    public function getVisual():IVisuals {
        return _visual;
    }

    public function getGraphics():DisplayObject {
        return _graphics;
    }

    public function getPreGraphics():DisplayObject {
        return _preGraphics;
    }

    public function setPosition(position:Point):void {
        _posX = position.x;
        _posY = position.y;
        updateGraphics();
    }

    public function setPreGraphicsPosition(position:Point):void {
        _posX = position.x;
        _posY = position.y;
        updatePreGraphics();
    }

    protected function updateGraphics():void {
        _graphics.x = _posX;
        _graphics.y = _posY;
    }

    protected function updatePreGraphics():void {
        _preGraphics.x = _posX;
        _preGraphics.y = _posY;
    }

    public function setOwner(owner:String):void {

        _owner = owner;
        _visual.setSide(owner);

        if(_owner != Game.getInstance().getPlayerName()){
            _graphics.rotation = Math.PI;
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

        //dummy entities have no ID
        if(_id != -1){
            Game.getInstance().addToDestroy(this);
        }

        if(_graphics.parent){
            _graphics.parent.removeChild(_graphics);
        }

    }

    public function debugVisuals(color:uint):void {

        _visual.debug();

    }

    public function get entitySize():Number {
        return _entitySize;
    }
















}
}
