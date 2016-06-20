package entities {
import flash.geom.Point;

public class EntityFactory {

    private static var _instance:EntityFactory;
    private var _autoIncrement:int;

    public function createEntity(entityName:String, owner:String, position:Point, params:Object = null):Entity {

        var entity:Entity;
        var id:int = owner == "playerOne" ? 100000 : 200000;
        id += ++_autoIncrement;
        //trace(id, "  ", entityName);
        switch(entityName){

            case "core":
                entity = new Entity(id, "core", "core", {hitPoints: 1000});
                break;


            ///////////// SPAWNERS /////////////

            case "SMT1":

                entity = new Entity(id, "spawner", "SMT1", {hitPoints: 100, price: 7, spawnRate: 1, spawn: "MT1", update: ["spawn"]});
                break;

            case "SMT2":

                entity = new Entity(id, "spawner", "SMT2", {hitPoints: 200, price: 15, spawnRate: 1.5, spawn: "MT2", update: ["spawn"]});
                break;

            ///////////// UNITS /////////////

            case "MT1":

                entity = new Entity(id, "unit", "MT1", {hitPoints: 100, speed: 1, range: 100, shootRate: 0.69, bullet: "MT1Bullet", update: ["move", "shoot"]});
                break;

            case "MT2":

                entity = new Entity(id, "unit", "MT2", {hitPoints: 100, speed: 2, range: 250, damage: 12, update: ["move"]});
                break;

            ///////////// BULLETS /////////////

            case "MT1Bullet":

                entity = new Entity(id, "bullet", "MT1Bullet", {speed: 2, damage: 12, update: ["move"]});
                break;



            default: throw new Error("WTF?");

        }

        if(params){
            entity.setParams(params);
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
