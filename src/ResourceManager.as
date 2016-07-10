package {
import starling.utils.AssetManager;
import starling.utils.Color;

public class ResourceManager {

    //game colors
    public static var GRAY:uint = 0x6D6D6D;
    public static var RED:uint = 0xFF0000;
    public static var GREEN:uint = 0x00FF00;


    private static var _assets:AssetManager;


    public static function addAssetManager(assets:AssetManager):void {
        _assets = assets;
    }

    public static function getAssetManager():AssetManager {
        return _assets;
    }

}
}
