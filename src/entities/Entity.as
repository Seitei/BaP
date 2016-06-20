package entities {

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.utils.Color;

public class Entity{

    private var _visual:DisplayObject;
    private var _entityName:String;
    private var _owner:String;
    private var _damage:int;
    private var _price:int;
    private var _hitPoints:int;
    private var _range:Number;
    private var _speed:int;
    private var _posX:Number;
    private var _posY:Number;
    private var _wayPoints:Array;
    private var _id:int;
    private var _spawnRate:Number;
    private var _shootRate:Number;
    private var _spawn:String;
    private var _updateFunctions:Array;
    private var _spawnCounter:Number = 0;
    private var _shootCounter:Number = 0;
    private var _incrementX:Number;
    private var _incrementY:Number;
    private var _currentWayPoint:int;
    private var _distanceWalked:Number = 0;
    private var _distanceToWayPoint:Number;
    private var _distanceIncrement:Number;
    private var _stopDoingIt:Boolean;
    private var _bullet:String;
    private var _entityType:String;
    private var _shootableEnemyEntities:Vector.<Entity>;
    private var _shooting:Boolean;
    private var _positionXHelper:Number;
    private var _positionYHelper:Number;
    private var _currentTarget:Entity;
    private var _walkingToFinalWayPoint:Boolean;
    private var _maxUnits:int = 50;
    private var _spawnedUnits:int;
    private var _destroyed:Boolean;

    public function Entity(id:int, entityType:String, entityName:String, params:Object) {

        _id = id;
        _entityType = entityType;
        _entityName = entityName;
        _visual = new Image(ResourceManager.getAssetManager().getTexture(entityName));
        _visual.pivotX = _visual.width / 2;
        _visual.pivotY = _visual.height / 2;
        _wayPoints = new Array();
        _updateFunctions = new Array();

        setParams(params);

    }

    public function setParams(params:Object):void {

        //TODO change this to a behaviors system
        for(var key:String in params){

            if(key == "update"){

                var updateFunctions:Array = params[key];

                for(var i:int = 0; i < updateFunctions.length; i++){

                    _updateFunctions.push(updateFunctions[i]);

                }

            }
            else {

                this["_" + key] = params[key];

            }

        }

    }

    public function getEntityType():String {
        return _entityType;
    }

    private function executeShot():void {

        _shootCounter ++;

        if(_shootCounter >= _shootRate * 60){

            Game.getInstance().createEntity(_bullet, _owner, getPosition(), false, {wayPoints: [new Point(_posX, _posY), _currentTarget.getPosition()], currentTarget: _currentTarget});
            _shootCounter = 0;

        }

    }

    public function updateHP(value:Number):void {
        _hitPoints += value;
        /*if(_hitPoints <= 0){
            destroy();
        }*/
    }

    private function shoot():void {

        if(_shooting){

            executeShot();

        }
        else {

            for(var i:int = 0; i < _shootableEnemyEntities.length; i++){

                _positionXHelper = _shootableEnemyEntities[i].getPosition().x;
                _positionYHelper = _shootableEnemyEntities[i].getPosition().y;

                if(Math.sqrt((_posX - _positionXHelper) * (_posX - _positionXHelper) + ( _posY - _positionYHelper) * ( _posY - _positionYHelper)) <= _range){

                    _currentTarget = _shootableEnemyEntities[i];
                    _shooting = true;

                }

            }
        }

    }

    public function destroy():void {

        _destroyed = true;
        Game.getInstance().addToDestroy(this);
        _visual.parent.removeChild(_visual);
    }

    public function debugVisuals():void {

        Image(_visual).color = Color.AQUA;

    }


    private function spawn():void {

        if(_maxUnits == _spawnedUnits){
            return;
        }

        _spawnCounter ++;

        if(_spawnCounter == _spawnRate * 60){

            Game.getInstance().createEntity(_spawn, _owner, getPosition(), false, {wayPoints: _wayPoints});
            _spawnCounter = 0;
            _spawnedUnits ++;

        }
   }

    private function move():void {

        if(_shooting){
            return;
        }

        if(_distanceWalked == 0 || _distanceWalked >= _distanceToWayPoint){

            calculateNewPath();

        }

        _distanceWalked += _distanceIncrement;

        _posX += _incrementX;
        _posY += _incrementY;

        updateVisuals();

    }

    private function calculateNewPath():void {

        if(_walkingToFinalWayPoint){

            _updateFunctions.splice(_updateFunctions.indexOf(move), 1);

            //TODO remove when implementing behaviors

            if(_entityType == "bullet"){
                _currentTarget.updateHP(-_damage);
                destroy();
            }

            return;

        }

        _distanceWalked = 0;
        _currentWayPoint ++;

        if(_currentWayPoint == _wayPoints.length - 1){
            _walkingToFinalWayPoint = true;
        }

        var segmentX:Number = _wayPoints[_currentWayPoint].x - _wayPoints[_currentWayPoint - 1].x;
        var segmentY:Number = _wayPoints[_currentWayPoint].y - _wayPoints[_currentWayPoint - 1].y;

        var rotation:Number = Math.atan2(segmentY, segmentX);
        _distanceToWayPoint = Math.sqrt((segmentX * segmentX) + ( segmentY * segmentY));

        _incrementX = Math.cos(rotation) * _speed;
        _incrementY = Math.sin(rotation) * _speed;

        _distanceIncrement = Math.sqrt((_incrementX * _incrementX) + ( _incrementY * _incrementY));

    }

    public function setWayPoints(array:Array):void {
        _wayPoints = array;
    }

    public function getWayPoints():Array {
        return _wayPoints;
    }


    public function getId():int {
        return _id;
    }

    public function update():void {

        for(var i:int = 0; i < _updateFunctions.length; i++){

            this[_updateFunctions[i]]();

        }
    }

    public function getVisual():DisplayObject {
        return _visual;
    }

    public function setPosition(position:Point):void {

        _posX = position.x;
        _posY = position.y;
        updateVisuals();

    }

    private function updateVisuals():void {
        _visual.x = _posX;
        _visual.y = _posY;
    }

    public function setOwner(owner:String):void {

        _owner = owner;
        Image(_visual).color = _owner == Game.getInstance().getPlayer() ? Color.GREEN : Color.RED;

        _shootableEnemyEntities = owner == "playerOne" ? Game.getInstance().getEntitiesSubGroup("shootablePlayerTwoEntities") : Game.getInstance().getEntitiesSubGroup("shootablePlayerOneEntities");

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

    public function onDestroy():void {


    }

























}
}
