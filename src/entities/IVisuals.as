package entities {
import starling.display.DisplayObject;

public interface IVisuals {

    function setSide(owner:String):void;
    function build(entity:Entity):void;
    function getGraphics():DisplayObject;
    function debug():void;
    function getPreGraphics():DisplayObject;
    function enablePreGraphics():void;
    function disablePreGraphics():void;

}
}
