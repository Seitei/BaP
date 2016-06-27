package entities {
import flash.geom.Point;
import flash.utils.Dictionary;

public class EntityFactory {

    private static var _instance:EntityFactory;
    private var _autoIncrement:int;
    private var _data:Dictionary;

    public function createEntity(entityName:String, owner:String, position:Point):Entity {

        var entity:Entity;
        var id:int = owner == "playerOne" ? 100000 : 200000;
        id += ++_autoIncrement;
        _data = EntitiesData.data[entityName];

        //TODO eventually, obtain entities values from the server
        switch(entityName){

            case "CORE":
                entity = new Core(id, entityName, _data[EntitiesData.HITPOINTS]);
                break;

            case "SMT1":
            case "SMT2":

                entity = new Spawner(id, entityName, _data[EntitiesData.HITPOINTS], _data[EntitiesData.MAX_UNITS], _data[EntitiesData.SPAWN_RATE], _data[EntitiesData.ENTITY_TO_SPAWN], _data[EntitiesData.PRICE]);
                break;

            case "MT1":
            case "MT2":

                entity = new Unit(id, entityName, _data[EntitiesData.HITPOINTS], _data[EntitiesData.SHOOT_RATE], _data[EntitiesData.BULLET], _data[EntitiesData.RANGE], _data[EntitiesData.SPEED]);
                break;

            case "MT1Bullet":
            case "MT2Bullet":

                entity = new Bullet(id, entityName, _data[EntitiesData.SPEED], _data[EntitiesData.DAMAGE]);
                break;

            default: throw new Error("WTF?");

        }


        entity.setPosition(position);
        entity.setOwner(owner);
        return entity;


    }


    public static function getInstance():EntityFactory {

        if(!_instance){
            _instance = new EntityFactory();
        }
        return _instance;

    }


}
}
