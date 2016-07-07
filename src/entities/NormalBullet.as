package entities {

public class NormalBullet extends Entity implements IBullet {

    private var _distanceIncrement:Number;
    private var _incrementX:Number;
    private var _incrementY:Number;
    private var _speed:Number;
    private var _distanceWalked:Number;
    private var _distanceToTarget:Number;
    private var _currentTarget:Entity;
    private var _damage:Number;

    public function NormalBullet(id:int, entityName:String) {

        super(id, "bullet", entityName);

    }

    public function setDamage(value:Number):void {
        _damage = value;
    }

    public function setSpeed(value:Number):void {
        _speed = value;
    }

    public function setTarget(value:Entity):void {
        _currentTarget = value;
        calculatePath();
    }

    private function move():void {

        if(_distanceWalked >= _distanceToTarget - _currentTarget.entitySize){

            _currentTarget.updateHP(-_damage);
            destroy();

        }

        _distanceWalked += _distanceIncrement;

        _posX += _incrementX;
        _posY += _incrementY;

        updateGraphics();

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
