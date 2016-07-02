package entities {
import starling.utils.Color;

public class Unit extends Entity {

    private var _wayPoints:Array;
    private var _counter:int;
    private var _shootRate:Number;
    private var _bullet:String;
    private var _currentTarget:Entity;
    private var _shooting:Boolean;
    private var _shootableEnemyEntities:Vector.<Entity>;
    private var _distanceWalked:Number = 0;
    private var _distanceToWayPoint:Number;
    private var _positionXHelper:Number;
    private var _positionYHelper:Number;
    private var _range:Number;
    private var _distanceIncrement:Number;
    private var _incrementX:Number;
    private var _incrementY:Number;
    private var _currentWayPoint:int;
    private var _speed:Number;
    private var _spawner:Spawner;


    public function Unit(id:int, entityName:String, hitPoints: int, shootRate:Number, bullet:String, range:Number, speed:Number) {

        super(id, "unit", entityName);

        _shootRate = shootRate;
        _bullet = bullet;
        _range = range;
        _speed = speed;
        _hitPoints = hitPoints;

    }

    public function setSpawner(spawner:Spawner):void {
        _spawner = spawner;
    }

    private function executeShot():void {

        _counter ++;

        if(_counter >= _shootRate * 60){

            Bullet(Game.getInstance().createEntity(_bullet, _owner, getPosition(), false)).setCurrentTarget(_currentTarget);
            _counter = 0;

        }

    }

    private function shoot():void {

        if(_shooting){

            if(_currentTarget.isDestroyed()){
                _shooting = false;
                _currentTarget = null;
            }
            else {
                executeShot();
            }

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


    override public function update():void {
        move();
        shoot();
    }


    override public function setOwner(owner:String):void {

        super.setOwner(owner);
        _shootableEnemyEntities = _owner == "playerOne" ? Game.getInstance().getEntitiesSubGroup("shootablePlayerTwoEntities") : Game.getInstance().getEntitiesSubGroup("shootablePlayerOneEntities");

    }

    private function calculateNewPath():void {

        _distanceWalked = 0;
        _currentWayPoint ++;

        var segmentX:Number = _wayPoints[_currentWayPoint].x - _wayPoints[_currentWayPoint - 1].x;
        var segmentY:Number = _wayPoints[_currentWayPoint].y - _wayPoints[_currentWayPoint - 1].y;

        var rotation:Number = Math.atan2(segmentY, segmentX);
        _distanceToWayPoint = Math.sqrt((segmentX * segmentX) + ( segmentY * segmentY));

        _incrementX = Math.cos(rotation) * _speed;
        _incrementY = Math.sin(rotation) * _speed;

        _distanceIncrement = Math.sqrt((_incrementX * _incrementX) + ( _incrementY * _incrementY));

        setRotation(rotation + 90 * Math.PI / 180);

    }

    private function setRotation(rotation:Number):void {
        _visual.rotation = rotation;
    }



    public function setWayPoints(array:Array):void {
        _wayPoints = array;
    }

    public function getWayPoints():Array {
        return _wayPoints;
    }


    override public function destroy():void {
        super.destroy();
        _spawner.unitDestroyed(this);
    }
}
}
