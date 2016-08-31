package entities {
import entities.visuals.SpawnerVisuals;

import ui.HudLayer;

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

        _entityToSpawn = entityToSpawn;
        _maxUnits = maxUnits;
        _spawnRate = spawnRate;
        _price = price;
        _hitPoints = hitPoints;
        _units = new <Unit>[];

    }

    public function spawn():void {

        if(_maxUnits == _spawnedUnits){
            return;
        }

        _spawnCounter ++;
        SpawnerVisuals(_visual).updateLoad(_spawnCounter / (_spawnRate * 60));

        if(_spawnCounter == _spawnRate * 60){
            var unit:Unit = Unit(Game.getInstance().createEntity(_entityToSpawn, _owner, getPosition(), false));
            unit.setWayPoints(_wayPoints);
            _units.push(unit);
            unit.setSpawner(this);


            _spawnCounter = 0;
            _spawnedUnits ++;

        }
    }

    public function getEntityToSpawn():String {
        return _entityToSpawn;
    }

    public function getUnits():Vector.<Unit> {
        return _units;
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


    override public function updateHP(value:Number):void {
        super.updateHP(value);
    }

    override public function destroy():void {
        super.destroy();
        HudLayer.getInstance().removePath(_id);
    }
}
}
