package entities {
import flash.geom.Point;

public class EntityFactory {

    private static var _instance:EntityFactory;
    private var _autoIncrement:int;

    public function createEntity(entityName:String, owner:String, position:Point):Entity {

        var entity:Entity;
        var id:int = owner == "playerOne" ? 100000 : 200000;
        id += ++_autoIncrement;

        switch(entityName){

            case "core":
                entity = new Core(id, "core", 1000);
                break;


            ///////////// SPAWNERS /////////////

            case "SMT1":

                entity = new Spawner(id, "SMT1", 100, 1, 1, "MT1", 10);
                break;

            case "SMT2":

                entity = new Spawner(id, "SMT2", 200, 8, 2, "MT2", 20);
                break;

            ///////////// UNITS /////////////

            case "MT1":

                entity = new Unit(id, "MT1", 50, 0.69, "MT1Bullet", 50, 1);
                break;

            case "MT2":
                entity = new Unit(id, "MT2", 70, 0.49, "MT2Bullet", 35, 1);
                break;

            ///////////// BULLETS /////////////

            case "MT1Bullet":

                entity = new Bullet(id, "MT1Bullet", 2, 12);
                break;

            case "MT2Bullet":

                entity = new Bullet(id, "MT2Bullet", 1, 22);
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
