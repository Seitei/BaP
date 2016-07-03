package entities {

public class Tower extends Entity {

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


    public function Tower(id:int, entityName:String, hitPoints: int, shootRate:Number, bullet:String, damage:Number, range:Number) {

        super(id, "unit", entityName);

        _shootRate = shootRate;
        _bullet = bullet;
        _range = range;
        _damage = damage;
        _hitPoints = hitPoints;

    }

    private function executeShot():void {

        _counter ++;

        if(_counter >= _shootRate * 60){

            var entity:Entity = Game.getInstance().createEntity(_bullet, _owner, getPosition(), false);
            IBullet(entity).setTarget(_currentTarget);
            IBullet(entity).setDamage(_damage);

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
