package entities {

public class Bullet extends Entity {

    private var _distanceIncrement:Number;
    private var _incrementX:Number;
    private var _incrementY:Number;
    private var _speed:Number;
    private var _distanceWalked:Number;
    private var _distanceToTarget:Number;
    private var _currentTarget:Entity;
    private var _damage:Number;

    public function Bullet(id:int, entityName:String, speed:Number, damage:Number) {

        super(id, "bullet", entityName);

        _speed = speed;
        _damage = damage;

    }

    public function setCurrentTarget(entity:Entity):void {

        _currentTarget = entity;
        calculatePath();

    }

    private function move():void {

        if(_distanceWalked >= _distanceToTarget){

            _currentTarget.updateHP(-_damage);
            destroy();

        }

        _distanceWalked += _distanceIncrement;

        _posX += _incrementX;
        _posY += _incrementY;

        updateVisuals();

    }


    override public function update():void {
        move();
    }

    private function calculatePath():void {

        _distanceWalked = 0;

        var segmentX:Number = _currentTarget.getPosition().x - _posX;
        var segmentY:Number = _currentTarget.getPosition().y - _posY;

        var rotation:Number = Math.atan2(segmentY, segmentX);
        _distanceToTarget = Math.sqrt((segmentX * segmentX) + ( segmentY * segmentY));

        _incrementX = Math.cos(rotation) * _speed;
        _incrementY = Math.sin(rotation) * _speed;

        _distanceIncrement = Math.sqrt((_incrementX * _incrementX) + ( _incrementY * _incrementY));

    }


    override public function destroy():void {

        super.destroy();


    }










}
}
