package entities {

public class CreditsBooster extends Entity implements IExecuteOnTurnStart{

    private var _price:int;
    private var _creditsRate:int;

    public function CreditsBooster(id:int, entityName:String, hitPoints:Number, price:int, creditsRate:int) {

        super(id, "support", entityName);
        _price = price;
        _hitPoints = hitPoints;
        _creditsRate = creditsRate;

    }

    override public function destroy():void {

        super.destroy();

    }

    public function executeOnTurnStart():void {
        Game.getInstance().getPlayer().updateCredits(_creditsRate);
    }








}
}
