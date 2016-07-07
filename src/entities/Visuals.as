package entities {
import starling.display.DisplayObject;
import starling.display.Image;
import starling.utils.Color;

public class Visuals implements IVisuals{

    protected var _entityName:String;
    protected var _entityShape:Image;
    protected var _graphics:DisplayObject;
    protected var _preGraphics:DisplayObject;

    public function Visuals() {

    }

    //override this to change entity's visual behavior
    public function build(entity:Entity):void {

        //graphics
        _entityName = entity.getEntityName();
        _entityShape = new Image(ResourceManager.getAssetManager().getTexture(_entityName));

        _graphics = _entityShape;
        _graphics.pivotX = _graphics.width / 2;
        _graphics.pivotY = _graphics.height / 2;

    }

    public function getSize():Number {
        return _graphics.width;
    }

    public function getGraphics():DisplayObject{
        return _graphics;
    }

    public function setSide(owner:String):void {

        if(owner != Game.getInstance().getPlayerName()){
            setColor(Color.RED);
        }
        else {
            setColor(Color.GREEN);
        }

    }

    public function getPreGraphics():DisplayObject {
        return _preGraphics;
    }

    public function enablePreGraphics():void {
        _preGraphics.alpha = 0.5;
    }

    public function disablePreGraphics():void {
        _preGraphics.alpha = 0.2;
    }

    protected function setColor(color:uint):void {
        _entityShape.color = color;
    }

    public function debug():void {
        // implement debug features;
    }











}

}
