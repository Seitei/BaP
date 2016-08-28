package entities {

public class NormalBullet extends Entity implements IBullet {

    private var _distanceIncrement:Number;
    private var _incrementX:Number;
    private var _incrementY:Number;
    private var _speed:Number;
    private var _distanceWalked:Number;
    private var _distanceToTarget:Number;
    private var _bulletDispersionArray:Array;
    protected var _currentTarget:Entity;
    protected var _damage:Number;
    protected var _areaRadius:Number;


    public function NormalBullet(id:int, entityName:String) {

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

    public function setTarget(value:Entity):void {
        _currentTarget = value;

        if(Game.getInstance().getPlayerName() != _owner){
            _bulletDispersionArray = EntitiesData.getAbstract(_currentTarget.getEntityName(), EntitiesData.ABSTRACTS_INVERTED);
        }
        else {
            _bulletDispersionArray = EntitiesData.getAbstract(_currentTarget.getEntityName(), EntitiesData.ABSTRACTS);
        }

        calculatePath();
    }

    public function setAreaRadius(value:Number):void {
        _areaRadius = value;
    }

    private function move():void {

        if(_distanceWalked >= _distanceToTarget){

            applyEffect();
            destroy();

        }

        _distanceWalked += _distanceIncrement;

        _posX += _incrementX;
        _posY += _incrementY;

        updateGraphics();

    }

    protected function applyEffect():void {
        _currentTarget.updateHP(-_damage);
    }

    override public function update():void {
        move();
    }

    private function calculatePath():void {

        _distanceWalked = 0;
        //var randomPoint:int = Math.random() * _bulletDispersionArray.length;
        var randomPoint:int = 1;

        var dispersionX:Number = _bulletDispersionArray[randomPoint].offsetX;
        var dispersionY:Number = _bulletDispersionArray[randomPoint].offsetY;

        var segmentX:Number = _currentTarget.getPosition().x - _posX + dispersionX;
        var segmentY:Number = _currentTarget.getPosition().y - _posY + dispersionY;

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
