package entities {

public class Spawner extends Entity implements IBuyable, ISpawner{

    private var _maxUnits:int = 5;
    private var _spawnedUnits:int;
    private var _spawnCounter:int;
    private var _spawnRate:Number;
    private var _entityToSpawn:String;
    private var _wayPoints:Array;
    private var _price:int;
    private var _units:Vector.<Unit>;

    public function Spawner(id:int, entityName:String, hitPoints: int, maxUnits:int, spawnRate: Number, entityToSpawn:String, price:int) {

        super(id, "spawner", entityName);

        _maxUnits = maxUnits;
        _spawnRate = spawnRate;
        _entityToSpawn = entityToSpawn;
        _price = price;
        _hitPoints = hitPoints;
        _units = new <Unit>[];

    }

    public function spawn():void {

        if(_maxUnits == _spawnedUnits){
            return;
        }

        _spawnCounter ++;

        if(_spawnCounter == _spawnRate * 60){

            var unit:Unit = Unit(Game.getInstance().createEntity(_entityToSpawn, _owner, getPosition(), false));
            unit.setWayPoints(_wayPoints);
            unit.setSpawner(this);
            _units.push(unit);

            _spawnCounter = 0;
            _spawnedUnits ++;

        }
    }

    public function getPrice():Number {
        return _price;
    }

    public function unitDestroyed(unit:Unit):void {
        _spawnedUnits --;
        _units.splice(_units.indexOf(unit), 1);
    }

    override public function update():void {

        spawn();

    }

    public function setWayPoints(array:Array):void {
        _wayPoints = array;
    }

    public function getWayPoints():Array {
        return _wayPoints;
    }



}
}
