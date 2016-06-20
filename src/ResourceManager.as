package {
import starling.utils.AssetManager;

public class ResourceManager {

    private static var _assets:AssetManager;

    public static function addAssetManager(assets:AssetManager):void {
        _assets = assets;
    }

    public static function getAssetManager():AssetManager {
        return _assets;
    }

}
}
