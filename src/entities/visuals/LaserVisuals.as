package entities.visuals {
import entities.*;
import entities.LaserBullet;

import starling.animation.Tween;
import starling.core.Starling;

import starling.display.Image;
import starling.display.Quad;

public class LaserVisuals extends Visuals implements IVisuals{

    public function SpawnerVisuals():void {

    }

    override public function build(entity:Entity):void {

        _entity = entity;
        _graphics = new Image(ResourceManager.getAssetManager().getTexture("shoot_fill"));

        //pre-graphics
        _preGraphics = new Quad(1,1);

    }

    override public function updateGraphics():void {

        var segmentX:Number = LaserBullet(_entity).getTarget().getPosition().x - _entity.getPosition().x;
        var segmentY:Number = LaserBullet(_entity).getTarget().getPosition().y - _entity.getPosition().y;

        var rotation:Number = Math.atan2(segmentY, segmentX);
        _graphics.x = _entity.getPosition().x;
        _graphics.y = _entity.getPosition().y;

        _graphics.width = Math.sqrt((segmentX * segmentX) + ( segmentY * segmentY));
        _graphics.rotation = rotation;

        var tween:Tween = new Tween(_graphics, 0.5);
        Starling.juggler.add(tween);
        tween.animate("alpha", 0);
        tween.onComplete = destroy;

    }

    override protected function setColor(color:uint):void {
        Image(_graphics).color = color;
    }


}

}
