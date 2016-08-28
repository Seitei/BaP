package {
import entities.EntitiesData;

import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.MovieClip;
import flash.events.Event;
import flash.geom.Point;
import flash.net.URLRequest;

import starling.utils.AssetManager;

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

    public static function loadSWFData():void {

        var loader:Loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
        loader.load(new URLRequest("assets/abstracts.swf"));

    }


    private static function onComplete(e:Event):void {

        var swf:MovieClip = LoaderInfo(e.currentTarget).content as MovieClip;

        for (var i:int = 0; i < swf.numChildren; i++) {

            var entityAbstract:MovieClip = swf.getChildAt(i) as MovieClip;
            var entityWidth:Number = _assets.getTexture(entityAbstract.name).width;
            var array:Array = new Array();
            var arrayInverted:Array = new Array();

            var centerX:Number = entityAbstract.getChildAt(0).x;
            var centerY:Number = entityAbstract.getChildAt(0).y;
            var mcWidth:Number = centerX * 2;

            for (var j:int = 0; j < entityAbstract.numChildren; j++) {

                var abstract:MovieClip = entityAbstract.getChildAt(j) as MovieClip;
                array.push({offsetX: (centerX - abstract.x) * entityWidth / mcWidth, offsetY: (centerY - abstract.y) * entityWidth / mcWidth});
                arrayInverted.push({offsetX: (abstract.x - centerX) * entityWidth / mcWidth, offsetY: (abstract.y - centerY) * entityWidth / mcWidth});

            }

            EntitiesData.setAbstract(entityAbstract.name, array, arrayInverted);

        }


    }


}
}
