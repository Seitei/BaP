package entities {

import starling.display.Image;
import starling.display.Quad;
import starling.display.Shape;
import starling.display.Sprite;
import starling.utils.Color;

public class SpawnerVisuals extends Visuals implements IVisuals{

    public function SpawnerVisuals() {

    }

    override public function build(entity:Entity):void {

        //graphics
        var container:Sprite = new Sprite();
        var spawnedEntity:Image = new Image(ResourceManager.getAssetManager().getTexture(Spawner(entity).getEntityToSpawn()));

        var backgroundCircle:Shape = new Shape();
        backgroundCircle.graphics.drawCircle(0, 0, spawnedEntity.width * 2);
        backgroundCircle.graphics.beginFill(0xBBBCBE);

        container.addChild(backgroundCircle);
        container.addChild(spawnedEntity);

        _graphics = container;

        //pre-graphics
        _preGraphics = new Quad(50, 50, Color.WHITE);
        _preGraphics.alpha = 0.5;


    }


    override protected function setColor(color:uint):void {
        //_entityShape.color = color;
    }








}

}
