package entities {
import flash.geom.Point;

import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;

public class HomingBullet extends Entity implements IBullet {

    private var _speed:Number;
    private var _bulletDispersionArray:Array;
    protected var _currentTarget:Entity;
    protected var _damage:Number;
    protected var _areaRadius:Number;
    private var _previousMotionStateTarget:String;
    private var _positionIncrement:Object;

    public function HomingBullet(id:int, entityName:String) {

        super(id, "bullet", entityName);

    }

    public function getTarget():Entity {
        return _currentTarget;
    }

    public function setDamage(value:Number):void {
        _damage = value;
    }

    public function setSpeed(value:Number):void {
        _speed = value;
    }


    override public function setPosition(position:Point):void {
        super.setPosition(position);
        _positionIncrement = new Object();
        _positionIncrement.x = _posX;
        _positionIncrement.y = _posY;
    }

    public function setTarget(value:Entity):void {
        _currentTarget = value;
        //_bulletDispersionArray = EntitiesData.getAbstract(_currentTarget.getEntityName());
        calculatePath();
    }

    public function setAreaRadius(value:Number):void {
        _areaRadius = value;
    }

    private function move():void {

        if(_previousMotionStateTarget != IMotion(_currentTarget).getMotionState()) {

            calculatePath();

        }

        _posX = _positionIncrement.x;
        _posY = _positionIncrement.y;

        updateGraphics();

    }

    override public function update():void {
        move();
    }

    private function calculatePath():void {

        var randomPoint:int = Math.random() * _bulletDispersionArray.length;

        var dispersionX:Number = _bulletDispersionArray[randomPoint].offsetX;
        var dispersionY:Number = _bulletDispersionArray[randomPoint].offsetY;

        var currentTargetX:Number = _currentTarget.getPosition().x;
        var currentTargetY:Number = _currentTarget.getPosition().y;

        var destinationDeltaX:Number = currentTargetX - _posX + dispersionX;
        var destinationDeltaY:Number = currentTargetY - _posY + dispersionY;

        var distance:Number = Math.sqrt((destinationDeltaX * destinationDeltaX) + ( destinationDeltaY * destinationDeltaY));

        var time:Number = distance / (_speed * 60);

        var currentTargetIncrementX:Number = IMotion(_currentTarget).getDirection().incrementX;
        var currentTargetIncrementY:Number = IMotion(_currentTarget).getDirection().incrementY;

        var tweenX:Tween  = new Tween(_positionIncrement, time, Transitions.LINEAR);
        tweenX.animate("x", currentTargetX + time * currentTargetIncrementX * 60 );
        tweenX.onComplete = onHit;

        var tweenY:Tween = new Tween(_positionIncrement, time, Transitions.LINEAR);
        tweenY.animate("y", currentTargetY + time * currentTargetIncrementY * 60);

        Starling.juggler.add(tweenX);
        Starling.juggler.add(tweenY);


        _previousMotionStateTarget = IMotion(_currentTarget).getMotionState();

    }


    private function onHit():void {
        applyEffect();
        destroy();
    }

    private function applyEffect():void {
        _currentTarget.updateHP(-_damage);
    }

    override public function destroy():void {

        super.destroy();


    }






}
}
