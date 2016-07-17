package entities {

import entities.ISpawner;

import starling.display.BlendMode;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.RenderTexture;

public class SpawnerVisuals extends Visuals implements IVisuals{

    private static const DEGREE:Number = Math.PI / 180;
    private var _loadingGraph:Image;

    public function SpawnerVisuals() {

    }

    override public function build(entity:Entity):void {

        //graphics
        var container:Sprite = new Sprite();

        var spawnedEntity:Image = new Image(ResourceManager.getAssetManager().getTexture(ISpawner(entity).getEntityToSpawn()));
        var backgroundCircle:Image = new Image(ResourceManager.getAssetManager().getTexture("spawner_bg"));
        backgroundCircle.color = ResourceManager.GRAY;

        spawnedEntity.pivotX = spawnedEntity.width / 2;
        spawnedEntity.pivotY = spawnedEntity.width / 2;
        spawnedEntity.blendMode = BlendMode.ERASE;

        spawnedEntity.x = spawnedEntity.y = backgroundCircle.width / 2;

        var rt:RenderTexture = new RenderTexture(backgroundCircle.width, backgroundCircle.height);
        rt.draw(backgroundCircle);
        spawnedEntity.x = spawnedEntity.y = backgroundCircle.width / 2;
        rt.draw(spawnedEntity);

        var backgroundOutCircle:Image = new Image(ResourceManager.getAssetManager().getTexture("spawner_bg_out_circle"));
        container.addChild(backgroundOutCircle);

        _loadingGraph = new Image(ResourceManager.getAssetManager().getTexture("spawner_loader"));
        _loadingGraph.pivotX = _loadingGraph.pivotY = _loadingGraph.width / 2;
        _loadingGraph.x = _loadingGraph.y = _loadingGraph.width / 2;

        var sprite:Sprite = new Sprite();
        sprite.addChild(_loadingGraph);
        sprite.mask = new Quad(_loadingGraph.width, _loadingGraph.height / 2);
        container.addChild(sprite);

        var image:Image = new Image(rt);
        image.pivotX = image.pivotY = image.width / 2;
        image.x = image.y = image.width / 2 + (backgroundOutCircle.width - image.width) / 2;
        container.addChild(image);

        _graphics = container;
        _graphics.pivotX = _graphics.pivotY = _graphics.width / 2;

        //pre-graphics
        _preGraphics = new Image(rt);
        _preGraphics.alpha = 0.5;
        _preGraphics.pivotX = _preGraphics.pivotY = _preGraphics.width / 2;


    }

    public function updateLoad(value:Number):void {
        _loadingGraph.rotation = 180 * DEGREE * value;
    }

    override protected function setColor(color:uint):void {
        _loadingGraph.color = color;
    }








}

}
