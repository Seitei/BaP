package entities {

public class Core extends Entity {


    public function Core(id:int, entityName:String, hitPoints:Number) {

        super(id, "core", entityName);
        _hitPoints = hitPoints;

    }

    override public function destroy():void {


        super.destroy();

        ////////// end game here //////////


    }


    override public function update():void {
        debugVisuals(false);
    }
}
}
