package entities {
import flash.utils.Dictionary;

public class EntityManager {

    public static const SHOOTABLE_PLAYER_ONE_ENTITITES:String = "shootablePlayerOneEntities";
    public static const SHOOTABLE_PLAYER_TWO_ENTITITES:String = "shootablePlayerTwoEntities";
    public static const PLAYER_ONE_ENTITIES:String = "playerOne";
    public static const PLAYER_TWO_ENTITIES:String = "playerTwo";

    private static var _instance:EntityManager;

    private var _entities:Vector.<Entity>;
    private var _entitiesDic:Dictionary;
    private var _entitiesSubGroups:Dictionary;
    private var _entitiesToDestroy:Vector.<Entity>;

    public function EntityManager() {

        _entities = new <Entity>[];
        _entitiesDic = new Dictionary();
        _entitiesSubGroups = new Dictionary();
        _entitiesToDestroy = new <Entity>[];


        _entitiesSubGroups[PLAYER_ONE_ENTITIES] = new Vector.<Entity>;
        _entitiesSubGroups[PLAYER_TWO_ENTITIES] = new Vector.<Entity>;
        _entitiesSubGroups[SHOOTABLE_PLAYER_ONE_ENTITITES] = new Vector.<Entity>;
        _entitiesSubGroups[SHOOTABLE_PLAYER_TWO_ENTITITES] = new Vector.<Entity>;

    }

    public function getEntitites():Vector.<Entity> {
        return _entities;
    }

    public function addEntity(entity:Entity):void {

        //all entities
        _entities.push(entity);
        //by ID
        _entitiesDic[entity.getId()] = entity;
        //by owner
        _entitiesSubGroups[entity.getOwner()].push(entity);

        //by subgroup
        //TODO change this in the future
        if(entity.getEntityType() != "bullet"){

            _entitiesSubGroups["shootable" + getOwnerCapitalized(entity.getOwner()) + "Entities"].push(entity);

        }

    }

    public function destroyEntity(entity:Entity):void {

        _entities.splice(_entities.indexOf(entity), 1);
        delete _entitiesDic[entity.getId()];
        _entitiesSubGroups[entity.getOwner()].splice(_entitiesSubGroups[entity.getOwner()].indexOf(entity), 1);

        //TODO change this in the future
        if(entity.getEntityType() != "bullet"){

            _entitiesSubGroups["shootable" + getOwnerCapitalized(entity.getOwner()) + "Entities"].splice(_entitiesSubGroups["shootable" + getOwnerCapitalized(entity.getOwner()) + "Entities"].indexOf(entity), 1);

        }

        entity = null;

    }

    public function updateEntityByID(id:int, property:String, value:Object):void {
        _entitiesDic[id][property](value);
    }

    public function getEntityByID(id:int):Entity {
        return _entitiesDic[id];
    }

    public function getEntitiesSubGroup(subGroup:String):Vector.<Entity> {
        return _entitiesSubGroups[subGroup];
    }

    public function getShootableEnemyEntities(owner:String):Vector.<Entity> {
        return _entitiesSubGroups["shootable" + getOppositeOwnerCapitalized(owner) + "Entities"];
    }

    public function getEntityColorByID(id:int):uint {

        return _entitiesDic[id].getOwner() == Game.getInstance().getOppositePlayerName() ? ResourceManager.RED : ResourceManager.GREEN;

    }

    public function getOppositeOwner(owner:String):String {
        return owner == "playerOne" ? "playerTwo" : "playerOne";
    }

    public function getOppositeOwnerCapitalized(owner:String):String {
        var string:String = getOppositeOwner(owner);
        string = string.replace("p", "P");
        return string;
    }

    public function getOwnerCapitalized(owner:String):String {
        var string:String = owner;
        string = string.replace("p", "P");
        return string;
    }

    public function checkEntitiesToDestroy():void {

         if(_entitiesToDestroy.length > 0){
            for(var i:int = 0; i < _entitiesToDestroy.length; i++){
                destroyEntity(_entitiesToDestroy[i]);
            }
         }

         _entitiesToDestroy.splice(0, _entitiesToDestroy.length);

    }


    public static function getInstance():EntityManager {

        if(!_instance){
            _instance = new EntityManager();
        }
        return _instance;

    }



}
}




















