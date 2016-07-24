package entities.visuals {
import entities.*;

import starling.display.DisplayObject;

public interface IVisuals {

    function setSide(owner:String):void;
    function build(entity:Entity):void;
    function getGraphics():DisplayObject;
    function debug(value:Boolean):void;
    function getPreGraphics():DisplayObject;
    function enablePreGraphics():void;
    function disablePreGraphics():void;
    function getSize():Number;
    function destroy():void;
    function updateGraphics():void;

}
}
