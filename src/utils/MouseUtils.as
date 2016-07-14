package utils {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.ui.MouseCursorData;

public class MouseUtils {

    [Embed(source="/assets/mouse_cursor_waypoints.png")]
    private static var MouseCursorWaypoints:Class;


    //TODO implement for more types of mouses
    public static function setMouseCursor(cursor:String = null) {

        var cursorData:MouseCursorData = new MouseCursorData();
        cursorData.hotSpot = new Point(6, 6);
        var bitmapDatas:Vector.<BitmapData> = new Vector.<BitmapData>(1, true);
        var bitmap:Bitmap = new MouseCursorWaypoints();
        bitmapDatas[0] = bitmap.bitmapData;
        cursorData.data = bitmapDatas;
        Mouse.registerCursor("mouseCursorWaypoints", cursorData);
        Mouse.cursor = "mouseCursorWaypoints";

    }

    public static function reset():void {
        Mouse.cursor =  MouseCursor.AUTO;
        Mouse.show();
    }
}
}
