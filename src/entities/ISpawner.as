package entities {

public interface ISpawner {


    function spawn():void;
    function setWayPoints(array:Array):void;
    function getEntityToSpawn():String;

}
}
