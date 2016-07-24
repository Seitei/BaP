package entities {
import starling.animation.Transitions;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;

public class AoEBullet extends NormalBullet implements IBullet {

    private var _shootableEnemyEntities:Vector.<Entity>;
    private var _positionXHelper:Number;
    private var _positionYHelper:Number;
    private var _targets:Vector.<Entity>;
    private var _tween:Tween;
    private var _AoEFill:Image;

    public function AoEBullet(id:int, entityName:String) {

        super(id, entityName);
        _targets = new <Entity>[];
        _AoEFill = new Image(ResourceManager.getAssetManager().getTexture("aoe_fill"));
    }


    override protected function applyEffect():void {

        for(var i:int = 0; i < _shootableEnemyEntities.length; i++){

            _positionXHelper = _shootableEnemyEntities[i].getPosition().x;
            _positionYHelper = _shootableEnemyEntities[i].getPosition().y;

            if(Math.sqrt((_posX - _positionXHelper) * (_posX - _positionXHelper) + ( _posY - _positionYHelper) * ( _posY - _positionYHelper)) <= _areaRadius){

                _targets.push(_shootableEnemyEntities[i]);

            }

        }

        _AoEFill.color = EntityManager.getInstance().getEntityColorByID(_id);
        _AoEFill.pivotX = _AoEFill.pivotY = _AoEFill.width / 2;
        _AoEFill.x = _posX;
        _AoEFill.y = _posY;

        Game.getInstance().getEntitiesLayer().addChild(_AoEFill);

        _tween = new Tween(_AoEFill, 0.5, Transitions.EASE_IN_OUT);
        _tween.animate("alpha", 0);
        Starling.juggler.add(_tween);

        _tween.onComplete = onTweenComplete;


        for (var j:int = 0; j < _targets.length; j++) {

            _targets[j].updateHP(-_damage);

        }



    }

    private function onTweenComplete():void {
        Starling.juggler.remove(_tween);
        Game.getInstance().getEntitiesLayer().removeChild(_AoEFill);
    }

    override public function setOwner(owner:String):void {

        super.setOwner(owner);
        _shootableEnemyEntities = EntityManager.getInstance().getShootableEnemyEntities(this.getOwner());

    }


}
}
