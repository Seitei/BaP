package entities {
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;

public class Unit extends Entity {

    private static const DISTRIBUTION_INCREMENT:Number = 0.1;
    private static const ACCELERATION:Number = 0.5;
    private static const DISPERSION_TIME:int = 2 * 60;
    private var _wayPoints:Array;
    private var _counter:int;
    private var _shootRate:Number;
    private var _bullet:String;
    private var _bulletDamage:Number;
    private var _bulletSpeed:Number;
    private var _currentTarget:Entity;
    private var _shooting:Boolean;
    private var _shootableEnemyEntities:Vector.<Entity>;
    private var _distanceWalked:Number = 0;
    private var _distanceToWayPoint:Number;
    private var _positionXHelper:Number;
    private var _positionYHelper:Number;
    private var _range:Number;
    private var _incrementX:Number = 0;
    private var _incrementY:Number = 0;
    private var _currentWayPoint:int;
    private var _speed:Number;
    private var _spawner:Spawner;
    private var _bulletAoERadius:Number;
    private var _distributionIncrementX:Number = 0;
    private var _distributionIncrementY:Number = 0;
    private var _recalculatePath:Boolean;
    private var _positionIncrement:Object;
    private var _dispersionTime:int;



    public function Unit(id:int, entityName:String, hitPoints: int, shootRate:Number, bullet:String, bulletSpeed:Number, bulletDamage:Number, bulletAoERadius:Number, range:Number, speed:Number) {

        super(id, "unit", entityName);

        _shootRate = shootRate;
        _bullet = bullet;
        _range = range;
        _bulletDamage = bulletDamage;
        _speed = speed;
        _bulletAoERadius = bulletAoERadius;
        _bulletSpeed = bulletSpeed;
        _hitPoints = hitPoints;
        _positionIncrement = new Object();
        _positionIncrement.x = 0;
        _positionIncrement.y = 0;
        _positionIncrement.distanceIncrement = 0;

    }

    public function setSpawner(spawner:Spawner):void {
        _spawner = spawner;
        distributeSquadronPosition();
    }

    private function distributeSquadronPosition():void {

        var position:int = _spawner.getUnits().indexOf(this);

        switch(position){

            case 0:
                break;
            case 1:
                _distributionIncrementX += DISTRIBUTION_INCREMENT;
                break;
            case 2:
                _distributionIncrementX -= DISTRIBUTION_INCREMENT;
                break;
            case 3:
                _distributionIncrementY += DISTRIBUTION_INCREMENT;
                break;
            case 4:
                _distributionIncrementY -= DISTRIBUTION_INCREMENT;
                break;
        }
    }

    private function executeShot():void {

        _counter ++;

        if(_counter >= _shootRate * 60){

            var entity:Entity = Game.getInstance().createEntity(_bullet, _owner, getPosition(), false);
            IBullet(entity).setDamage(_bulletDamage);
            IBullet(entity).setSpeed(_bulletSpeed);
            IBullet(entity).setAreaRadius(_bulletAoERadius);
            IBullet(entity).setTarget(_currentTarget);
            _counter = 0;

        }

    }

    private function shoot():void {

        if(_shooting){

            if(!_currentTarget || _currentTarget.isDestroyed()){
                _shooting = false;
                _currentTarget = null;
                _recalculatePath = true;
                _positionIncrement.x = _positionIncrement.y = _positionIncrement.distanceIncrement = 0;
                _dispersionTime = 0;
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
                    accelerateMovement(0, onTweenComplete);

                }
            }
        }

    }

    private function move():void {

        if(_shooting){

            if(_dispersionTime <= DISPERSION_TIME){

                _posX += _distributionIncrementX;
                _posY += _distributionIncrementY

            }

            _dispersionTime ++;

        }
        else {

            if(_currentWayPoint == 0 || _distanceWalked >= _distanceToWayPoint || _recalculatePath){

                calculateNewPath();

            }

            _distanceWalked += _positionIncrement.distanceIncrement;

            _posX += _positionIncrement.x;
            _posY += _positionIncrement.y;

        }

        updateGraphics();

    }

    override public function update():void {
        move();
        shoot();
    }


    override public function setOwner(owner:String):void {
        super.setOwner(owner);
        _shootableEnemyEntities = EntityManager.getInstance().getShootableEnemyEntities(this.getOwner());
    }

    private function calculateNewPath():void {

        if(!_recalculatePath || _currentWayPoint == 0){
            _currentWayPoint ++;
        }

        _recalculatePath = false;

        _distanceWalked = 0;

        var segmentX:Number = _wayPoints[_currentWayPoint].x - _posX;
        var segmentY:Number = _wayPoints[_currentWayPoint].y - _posY;

        var rotation:Number = Math.atan2(segmentY, segmentX);
        _distanceToWayPoint = Math.sqrt((segmentX * segmentX) + ( segmentY * segmentY));

        _incrementX = Math.cos(rotation) * _speed;
        _incrementY = Math.sin(rotation) * _speed;

        setRotation(rotation + 90 * Math.PI / 180);

        if(_positionIncrement.distanceIncrement == 0){

            accelerateMovement(1);

        }
        else {

            _positionIncrement.x = _incrementX;
            _positionIncrement.y = _incrementY;

        }
    }

    private function accelerateMovement(acceleration:Number, onComplete:Function = null):void {

        var tween:Tween = new Tween(_positionIncrement, ACCELERATION, Transitions.LINEAR);
        Starling.juggler.add(tween);
        tween.animate("x", _incrementX * acceleration);
        tween.animate("y", _incrementY * acceleration);
        tween.animate("distanceIncrement", _speed * acceleration);

        if(onComplete){
            tween.onComplete = onComplete;
        }

    }

    private function onTweenComplete():void {
        _shooting = true;
        setRotation(-Math.PI / 2 + Math.atan2(_posY - _positionYHelper, _posX - _positionXHelper));
    }

    private function setRotation(rotation:Number):void {

        var tween:Tween = new Tween(_visual.getGraphics(), ACCELERATION / 2, Transitions.LINEAR);
        Starling.juggler.add(tween);
        tween.rotateTo(rotation);

    }


    public function setWayPoints(array:Array):void {
        _wayPoints = array;
    }

    public function getWayPoints():Array {
        return _wayPoints;
    }


    override public function destroy():void {
        _spawner.unitDestroyed(this);
        super.destroy();
    }
}
}
