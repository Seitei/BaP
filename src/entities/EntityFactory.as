package entities {
import entities.visuals.IVisuals;
import entities.visuals.LaserVisuals;
import entities.visuals.SpawnerVisuals;
import entities.visuals.Visuals;

import flash.geom.Point;
import flash.utils.Dictionary;

public class EntityFactory {

    private static var _instance:EntityFactory;
    private var _autoIncrement:int;
    private var _data:Dictionary;
    private var _spawnersIncrement:int;

    public function createEntity(entityName:String, owner:String, position:Point = null, dummy:Boolean = false):Entity {

        var entity:Entity;

        //the idea is, that you can create a new entity for other reasons
        //so you don't add it normally.
        var id:int = -1;

        if(!dummy){

            id = owner == "playerOne" ? 100000 : 200000;

            //TODO this is meant to avoid mixing IDs of spawners with other entities
            //TODO when any desync issues are detected and fixed, remove this, or keep it for debugging reasons

            if(entityName.substr(0, 1) == "S"){
                id += 50000;
                id += ++_spawnersIncrement;
            }
            else {
                id += ++_autoIncrement;
            }
        }

        _data = EntitiesData.data[entityName];
        var visuals:IVisuals;

        //trace(id, "  ", entityName);

        switch(entityName){

            case EntitiesData.CORE:
                entity = new Core(id, entityName, _data[EntitiesData.HITPOINTS]);
                visuals = new Visuals();
                break;

            case EntitiesData.SMT1:
            case EntitiesData.SMT2:
            case EntitiesData.SMT3:
            case EntitiesData.SRT1:
            case EntitiesData.SRT2:
            case EntitiesData.SRT3:

                entity = new Spawner(id, entityName, _data[EntitiesData.HITPOINTS], _data[EntitiesData.MAX_UNITS], _data[EntitiesData.SPAWN_RATE], _data[EntitiesData.ENTITY_TO_SPAWN], _data[EntitiesData.PRICE]);
                visuals = new SpawnerVisuals();
                break;

            case EntitiesData.MT1:
            case EntitiesData.MT2:
            case EntitiesData.MT3:
            case EntitiesData.RT1:
            case EntitiesData.RT2:
            case EntitiesData.RT3:

                entity = new Unit(id, entityName, _data[EntitiesData.HITPOINTS], _data[EntitiesData.SHOOT_RATE], _data[EntitiesData.BULLET], _data[EntitiesData.BULLET_SPEED], _data[EntitiesData.DAMAGE], _data[EntitiesData.AOE_RADIUS], _data[EntitiesData.RANGE], _data[EntitiesData.SPEED]);
                visuals = new Visuals();
                break;



            case EntitiesData.NORMAL_BULLET:
                entity = new NormalBullet(id, entityName);
                visuals = new Visuals();
                break;

            case EntitiesData.AOE_BULLET:
                entity = new AoEBullet(id, entityName);
                visuals = new Visuals();
                break;

            case EntitiesData.HOMING_BULLET:
                entity = new HomingBullet(id, entityName);
                visuals = new Visuals();
                break;

            case EntitiesData.LASER_BULLET:
                entity = new LaserBullet(id, entityName);
                visuals = new LaserVisuals();
                break;

            case EntitiesData.CB1:
            case EntitiesData.CB2:

                entity = new CreditsBooster(id, entityName, _data[EntitiesData.HITPOINTS], _data[EntitiesData.PRICE], _data[EntitiesData.CREDITS_RATE]);
                visuals = new Visuals();
                break;

            case EntitiesData.ROCKT1:
            case EntitiesData.ROCKT2:

                entity = new Rock(id, entityName, _data[EntitiesData.HITPOINTS], _data[EntitiesData.PRICE]);
                visuals = new Visuals();
                break;

            case EntitiesData.TOWERT1:
            case EntitiesData.TOWERT2:
            case EntitiesData.TOWERT3:

                entity = new Tower(id, entityName, _data[EntitiesData.PRICE], _data[EntitiesData.HITPOINTS], _data[EntitiesData.SHOOT_RATE], _data[EntitiesData.BULLET], _data[EntitiesData.BULLET_SPEED], _data[EntitiesData.DAMAGE], _data[EntitiesData.RANGE]);
                visuals = new Visuals();
                break;

            default: throw new Error("WTF?");

        }

        entity.buildVisuals(visuals);
        entity.setOwner(owner);
        if(position){
            entity.setPosition(position);
        }
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
