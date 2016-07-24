package entities {

public interface IBullet {

    function setDamage(value:Number):void;
    function setTarget(value:Entity):void;
    function setSpeed(value:Number):void;
    function getTarget():Entity;
    function setAreaRadius(value:Number):void;

}
}
