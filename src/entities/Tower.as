package entities {
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;

public class Tower extends Entity implements IBuyable{

    private var _counter:int;
    private var _shootRate:Number;
    private var _bullet:String;
    private var _currentTarget:Entity;
    private var _shooting:Boolean;
    private var _shootableEnemyEntities:Vector.<Entity>;
    private var _range:Number;
    private var _positionXHelper:Number;
    private var _positionYHelper:Number;
    private var _damage:Number;
    private var _price:Number;
    private var _bulletSpeed:Number;
    private var _rotationTween:Tween;


    public function Tower(id:int, entityName:String, price:Number, hitPoints: int, shootRate:Number, bullet:String, bulletSpeed:Number, damage:Number, range:Number) {

        super(id, "unit", entityName);

        _price = price;
        _shootRate = shootRate;
        _bullet = bullet;
        _range = range;
        _damage = damage;
        _bulletSpeed = bulletSpeed;
        _hitPoints = hitPoints;

    }


    public function getPrice():Number {
        return _price;
    }

    private function executeShot():void {

        _counter ++;

        if(_counter >= _shootRate * 60){

            var entity:Entity = Game.getInstance().createEntity(_bullet, _owner, getPosition(), false);
            IBullet(entity).setDamage(_damage);
            IBullet(entity).setSpeed(_bulletSpeed);
            IBullet(entity).setTarget(_currentTarget);

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
                    rotateToTarget(Math.atan2(_posY - _positionYHelper, _posX - _positionXHelper));

                }

            }
        }

    }

    private function rotateToTarget(angle:Number):void {
        _rotationTween = new Tween(_graphics, 0.5, Transitions.EASE_IN_OUT);
        _rotationTween.onComplete = onRotationTweenComplete;
        _rotationTween.rotateTo(- Math.PI / 2 + angle);
        Starling.juggler.add(_rotationTween);
    }

    private function onRotationTweenComplete():void {
        Starling.juggler.remove(_rotationTween);
        _shooting = true;
    }

    override public function update():void {
        shoot();
    }


    override public function setOwner(owner:String):void {

        super.setOwner(owner);
        _shootableEnemyEntities = _owner == "playerOne" ? Game.getInstance().getEntitiesSubGroup("shootablePlayerTwoEntities") : Game.getInstance().getEntitiesSubGroup("shootablePlayerOneEntities");

    }

    override public function destroy():void {

        super.destroy();

    }
}
}
