package entities {

public class Rock extends Entity{

    private var _price:int;

    public function Rock(id:int, entityName:String, hitPoints:Number, price:int) {

        super(id, "rock", entityName);
        _price = price;
        _hitPoints = hitPoints;

    }

}
}
