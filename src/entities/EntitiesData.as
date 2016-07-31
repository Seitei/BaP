package entities {
import flash.utils.Dictionary;

//TODO eventually, obtain entities values from the server

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
    public static const BULLET_SPEED:String = "bullet_speed";
    public static const DAMAGE:String = "damage";
    public static const AOE_RADIUS:String = "AoERadius";
    public static const CREDITS_RATE:String = "creditsRate";

    public static const CORE:String = "CORE";
    public static const SMT1:String = "SMT1";
    public static const SMT2:String = "SMT2";
    public static const SMT3:String = "SMT3";
    public static const SRT1:String = "SRT1";
    public static const SRT2:String = "SRT2";
    public static const SRT3:String = "SRT3";
    public static const MT1:String = "MT1";
    public static const MT2:String = "MT2";
    public static const MT3:String = "MT3";
    public static const RT1:String = "RT1";
    public static const RT2:String = "RT2";
    public static const RT3:String = "RT3";
    public static const NORMAL_BULLET:String = "NORMAL_BULLET";
    public static const AOE_BULLET:String = "AOE_BULLET";
    public static const LASER_BULLET:String = "LASER_BULLET";
    public static const CB1:String = "CREDITS_BOOSTERT1";
    public static const CB2:String = "CREDITS_BOOSTERT2";
    public static const TOWERT1:String = "TOWERT1";
    public static const TOWERT2:String = "TOWERT2";
    public static const TOWERT3:String = "TOWERT3";
    public static const ROCKT1:String = "ROCKT1";
    public static const ROCKT2:String = "ROCKT2";

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

    data[SMT2][HITPOINTS]       = 100;
    data[SMT2][MAX_UNITS]       = 3;
    data[SMT2][SPAWN_RATE]      = 1;
    data[SMT2][ENTITY_TO_SPAWN] = MT2;
    data[SMT2][PRICE]           = 15;

    data[SMT3] = new Dictionary();

    data[SMT3][HITPOINTS]       = 100;
    data[SMT3][MAX_UNITS]       = 3;
    data[SMT3][SPAWN_RATE]      = 1;
    data[SMT3][ENTITY_TO_SPAWN] = MT3;
    data[SMT3][PRICE]           = 25;

    data[SRT1] = new Dictionary();

    data[SRT1][HITPOINTS]       = 100;
    data[SRT1][MAX_UNITS]       = 3;
    data[SRT1][SPAWN_RATE]      = 1;
    data[SRT1][ENTITY_TO_SPAWN] = RT1;
    data[SRT1][PRICE]           = 10;


    data[SRT2] = new Dictionary();

    data[SRT2][HITPOINTS]       = 100;
    data[SRT2][MAX_UNITS]       = 3;
    data[SRT2][SPAWN_RATE]      = 1;
    data[SRT2][ENTITY_TO_SPAWN] = RT2;
    data[SRT2][PRICE]           = 15;

    data[SRT3] = new Dictionary();

    data[SRT3][HITPOINTS]       = 100;
    data[SRT3][MAX_UNITS]       = 3;
    data[SRT3][SPAWN_RATE]      = 1;
    data[SRT3][ENTITY_TO_SPAWN] = RT3;
    data[SRT3][PRICE]           = 25;



    ///////////// UNITS /////////////

    data[MT1] = new Dictionary();

    data[MT1][HITPOINTS]       = 20;
    data[MT1][SHOOT_RATE]      = 0.7;
    data[MT1][BULLET]          = NORMAL_BULLET;
    data[MT1][RANGE]           = 120;
    data[MT1][DAMAGE]          = 5;
    data[MT1][SPEED]           = 1;
    data[MT1][AOE_RADIUS]      = 1;
    data[MT1][BULLET_SPEED]    = 3;

    data[MT2] = new Dictionary();

    data[MT2][HITPOINTS]       = 75;
    data[MT2][SHOOT_RATE]      = 0.7;
    data[MT2][BULLET]          = NORMAL_BULLET;
    data[MT2][RANGE]           = 35;
    data[MT2][DAMAGE]          = 7;
    data[MT2][SPEED]           = 1.5;
    data[MT2][AOE_RADIUS]      = 1;
    data[MT2][BULLET_SPEED]    = 3;

    data[MT3] = new Dictionary();

    data[MT3][HITPOINTS]       = 50;
    data[MT3][SHOOT_RATE]      = 1;
    data[MT3][BULLET]          = AOE_BULLET;
    data[MT3][RANGE]           = 50;
    data[MT3][DAMAGE]          = 5;
    data[MT3][SPEED]           = 1;
    data[MT3][AOE_RADIUS]      = 30;
    data[MT3][BULLET_SPEED]    = 2;


    data[RT1] = new Dictionary();

    data[RT1][HITPOINTS]       = 10;
    data[RT1][SHOOT_RATE]      = 0.5;
    data[RT1][BULLET]          = NORMAL_BULLET;
    data[RT1][RANGE]           = 100;
    data[RT1][DAMAGE]          = 4;
    data[RT1][SPEED]           = 1;
    data[RT1][AOE_RADIUS]      = 1;
    data[RT1][BULLET_SPEED]    = 3;

    data[RT2] = new Dictionary();

    data[RT2][HITPOINTS]       = 15;
    data[RT2][SHOOT_RATE]      = 0.5;
    data[RT2][BULLET]          = NORMAL_BULLET;
    data[RT2][RANGE]           = 150;
    data[RT2][DAMAGE]          = 7;
    data[RT2][SPEED]           = 0.7;
    data[RT2][AOE_RADIUS]      = 1;
    data[RT2][BULLET_SPEED]    = 3;

    data[RT3] = new Dictionary();

    data[RT3][HITPOINTS]       = 50;
    data[RT3][SHOOT_RATE]      = 1;
    data[RT3][BULLET]          = LASER_BULLET;
    data[RT3][RANGE]           = 250;
    data[RT3][DAMAGE]          = 15;
    data[RT3][SPEED]           = 1;
    data[RT3][AOE_RADIUS]      = 1;
    data[RT3][BULLET_SPEED]    = 2;




    ///////////// SUPPORT /////////////


    data[CB1] = new Dictionary();

    data[CB1][HITPOINTS]           = 70;
    data[CB1][PRICE]               = 13;
    data[CB1][CREDITS_RATE]        = 2;


    data[CB2] = new Dictionary();

    data[CB2][HITPOINTS]           = 90;
    data[CB2][PRICE]               = 20;
    data[CB2][CREDITS_RATE]        = 4;


    ///////////// TOWERS /////////////

    data[TOWERT1] = new Dictionary();

    data[TOWERT1][HITPOINTS]           = 200;
    data[TOWERT1][PRICE]               = 7;
    data[TOWERT1][DAMAGE]              = 12;
    data[TOWERT1][BULLET]              = NORMAL_BULLET;
    data[TOWERT1][SHOOT_RATE]          = 0.5;
    data[TOWERT1][RANGE]               = 50;
    data[TOWERT1][BULLET_SPEED]        = 5;

    data[TOWERT2] = new Dictionary();

    data[TOWERT2][HITPOINTS]           = 200;
    data[TOWERT2][PRICE]               = 18;
    data[TOWERT2][BULLET]              = LASER_BULLET;
    data[TOWERT2][DAMAGE]              = 50;
    data[TOWERT2][SHOOT_RATE]          = 0.5;
    data[TOWERT2][RANGE]               = 170;
    data[TOWERT2][BULLET_SPEED]        = 2;

    data[TOWERT3] = new Dictionary();

    data[TOWERT3][HITPOINTS]           = 350;
    data[TOWERT3][PRICE]               = 35;
    data[TOWERT3][BULLET]              = AOE_BULLET;
    data[TOWERT3][DAMAGE]              = 50;
    data[TOWERT3][SHOOT_RATE]          = 0.5;
    data[TOWERT3][RANGE]               = 120;
    data[TOWERT3][AOE_RADIUS]          = 50;
    data[TOWERT3][BULLET_SPEED]        = 5;

    ///////////// ROCKS /////////////

    data[ROCKT1] = new Dictionary();

    data[ROCKT1][HITPOINTS]           = 500;
    data[ROCKT1][PRICE]               = 7;

    data[ROCKT2] = new Dictionary();

    data[ROCKT2][HITPOINTS]           = 150;
    data[ROCKT2][PRICE]               = 20;

















}
}
