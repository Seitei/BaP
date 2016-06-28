package entities {
import flash.utils.Dictionary;

public class EntitiesData {

    public static const HITPOINTS:String = "hitPoints";
    public static const MAX_UNITS:String = "maxUnits";
    public static const SPAWN_RATE:String = "spawnRate";
    public static const ENTITY_TO_SPAWN:String = "entityToSpawn";
    public static const PRICE:String = "price";
    public static const SHOOT_RATE:String = "shootRate";
    public static const BULLET:String = "bullet";
    public static const RANGE:String = "range";
    public static const SPEED:String = "speed";
    public static const DAMAGE:String = "damage";
    public static const CREDITS_RATE:String = "creditsRate";

    public static const CORE:String = "CORE";
    public static const SMT1:String = "SMT1";
    public static const SMT2:String = "SMT2";
    public static const MT1:String = "MT1";
    public static const MT2:String = "MT2";
    public static const MT1Bullet:String = "MT1Bullet";
    public static const MT2Bullet:String = "MT2Bullet";
    public static const CB1:String = "creditsBooster1";
    public static const CB2:String = "creditsBooster2";




    public static var data:Dictionary = new Dictionary();


    ///////////// CORE /////////////

    data[CORE] = new Dictionary();

    data[CORE][HITPOINTS]       = 1000;

    ///////////// SPAWNERS /////////////

    data[SMT1] = new Dictionary();

    data[SMT1][HITPOINTS]       = 100;
    data[SMT1][MAX_UNITS]       = 5;
    data[SMT1][SPAWN_RATE]      = 1;
    data[SMT1][ENTITY_TO_SPAWN] = MT1;
    data[SMT1][PRICE]           = 8;


    data[SMT2] = new Dictionary();

    data[SMT2][HITPOINTS]       = 200;
    data[SMT2][MAX_UNITS]       = 7;
    data[SMT2][SPAWN_RATE]      = 2;
    data[SMT2][ENTITY_TO_SPAWN] = MT2;
    data[SMT2][PRICE]           = 15;



    ///////////// UNITS /////////////

    data[MT1] = new Dictionary();

    data[MT1][HITPOINTS]       = 20;
    data[MT1][SHOOT_RATE]      = 1;
    data[MT1][BULLET]          = MT1Bullet;
    data[MT1][RANGE]           = 35;
    data[MT1][SPEED]           = 1;

    data[MT2] = new Dictionary();

    data[MT2][HITPOINTS]       = 50;
    data[MT2][SHOOT_RATE]      = 2;
    data[MT2][BULLET]          = MT2Bullet;
    data[MT2][RANGE]           = 25;
    data[MT2][SPEED]           = 2;



    ///////////// BULLETS /////////////


    data[MT1Bullet] = new Dictionary();

    data[MT1Bullet][SPEED]           = 1;
    data[MT1Bullet][DAMAGE]          = 12;


    data[MT2Bullet] = new Dictionary();

    data[MT2Bullet][SPEED]           = 1;
    data[MT2Bullet][DAMAGE]          = 22;


    ///////////// SUPPORT /////////////


    data[CB1] = new Dictionary();

    data[CB1][HITPOINTS]           = 70;
    data[CB1][PRICE]               = 13;
    data[CB1][CREDITS_RATE]        = 2;


    data[CB2] = new Dictionary();

    data[CB2][HITPOINTS]           = 90;
    data[CB2][PRICE]               = 20;
    data[CB2][CREDITS_RATE]        = 4;




















}
}
