package entities {

import entities.visuals.IVisuals;

import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import starling.display.DisplayObject;
import starling.filters.ColorMatrixFilter;

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
    private var _timer:Timer;


    public function Entity(id:int, entityType:String, entityName:String) {

        _id = id;
        _entityType = entityType;
        _entityName = entityName;
        //TODO remove from here
        _timer = new Timer(150, 1);
        _timer.addEventListener(TimerEvent.TIMER, onTimer);

    }

    public function buildVisuals(visuals:IVisuals):void {
        _visual = visuals;
        _visual.build(this);
        _graphics = _visual.getGraphics();
        _preGraphics = _visual.getPreGraphics();
        _entitySize = _visual.getSize();
        //debugVisuals(true);
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
        _visual.updateGraphics();
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
        //TODO remove this from here, implement utils helper
        _timer.start();
        _graphics.filter = new ColorMatrixFilter().adjustBrightness(0.5);
    }

    private function onTimer(event:TimerEvent):void {

        _graphics.filter = null;
        _timer.stop();

    }

    public function isDestroyed():Boolean {
        return _destroyed;
    }

    public function get entitySize():Number {
        return _entitySize;
    }

    public function destroy():void {

        _destroyed = true;

        //dummy entities have no ID
        if(_id != -1){
            EntityManager.getInstance().destroyEntity(this);
        }

        _visual.destroy();

        _timer.removeEventListener(TimerEvent.TIMER, onTimer);

    }

    public function debugVisuals(value:Boolean):void {

        _visual.debug(value);

    }

















}
}
