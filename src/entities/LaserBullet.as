package entities {
import flash.geom.Point;

public class LaserBullet extends NormalBullet implements IBullet {


    public function LaserBullet(id:int, entityName:String) {

        super(id, entityName);
    }

    override public function setTarget(value:Entity):void {

        super.setTarget(value);
        updateGraphics();
        applyEffect();
    }

    override public function update():void {
        //move();
    }

    override public function setPosition(position:Point):void {
        _posX = position.x;
        _posY = position.y;
    }



    override public function destroy():void {

        super.destroy();


    }


}
}
