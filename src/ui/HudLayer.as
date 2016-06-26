package ui {
import entities.Entity;
import entities.Spawner;

import flash.geom.Point;

import flash.geom.Point;
import flash.utils.Dictionary;

import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.utils.Color;

public class HudLayer extends Sprite{

    private static var _instance:HudLayer;
    private var _currentEntityID:int;
    private var _startPoint:Point;
    private var _paths:Dictionary;
    private var _linePaths:Dictionary;
    private var _enemyCorePosition:Point;
    private var _activeSegmentOne:Quad;
    private var _activeSegmentTwo:Quad;
    private var _temporaryLines:Array;
    private var _onPathFinished:Function;

    public function HudLayer() {

        _paths = new Dictionary();
        _linePaths = new Dictionary();
        _temporaryLines = new Array();

    }

    public function setEnemyCorePosition(position:Point):void{
        _enemyCorePosition = position;
    }

    public function beginPath(entity:Entity, onPathFinished:Function):void {

        _onPathFinished = onPathFinished;
        _currentEntityID = entity.getId();
        _paths[_currentEntityID] = [entity.getPosition()];
        _startPoint = entity.getPosition();
        _activeSegmentOne = new Quad(1, 1, Color.GREEN);
        _activeSegmentOne.x = _startPoint.x;
        _activeSegmentOne.y = _startPoint.y;
        addChild(_activeSegmentOne);
        _activeSegmentTwo = new Quad(1, 1, Color.GREEN);
        _activeSegmentTwo.x = _enemyCorePosition.x;
        _activeSegmentTwo.y = _enemyCorePosition.y;
        addChild(_activeSegmentTwo);
        Game.getInstance().addEventListener(TouchEvent.TOUCH, onTouch);

    }

    public function drawPath(id:int):void {

        var pointOne:Point;
        var pointTwo:Point;
        _linePaths[id] = new Array();

        for(var i:int = 0; i < _paths[id].length - 1; i++){

            pointOne = _paths[id][i];
            pointTwo = _paths[id][i + 1];

            var line:Quad = new Quad(1, 1, Game.getInstance().getEntityByID(id).getOwner() == Game.getInstance().getOppositePlayer() ? Color.RED : Color.GREEN);
            line.x = pointOne.x;
            line.y = pointOne.y;
            line.rotation = Math.atan2(pointTwo.y - pointOne.y, pointTwo.x - pointOne.x);
            line.scaleX = Math.sqrt((pointTwo.x - pointOne.x) * (pointTwo.x - pointOne.x) + ( pointTwo.y - pointOne.y) * ( pointTwo.y - pointOne.y));
            addChild(line);
            _linePaths[id].push(line);

        }
    }

    public function addPath(entity:Spawner):void {

        _paths[entity.getId()] = entity.getWayPoints();

    }


    public function removePath(id:String):void {

        for(var i:int = 0; i < _linePaths[id].length - 1; i++){

            removeChild(_linePaths[id][i]);
            _linePaths[id][i].dispose();

        }
    }

    private function onTouch(e:TouchEvent):void {

        var hover:Touch = e.getTouch(Game.getInstance(), TouchPhase.HOVER);
        var began:Touch = e.getTouch(Game.getInstance(), TouchPhase.BEGAN);
        var rightClickEnded:Touch = e.getTouch(Game.getInstance(), TouchPhase.RIGHT_ENDED);

        if(hover){
            updateCurrentPath(hover.globalX, hover.globalY);
        }

        if(began){

            var line:Quad = new Quad(1, 1, Color.GREEN);
            line.x = _activeSegmentOne.x;
            line.y = _activeSegmentOne.y;
            line.scaleX = _activeSegmentOne.scaleX;
            line.rotation = _activeSegmentOne.rotation;
            addChild(line);
            _temporaryLines.push(line);

            _activeSegmentOne.x = began.globalX;
            _activeSegmentOne.y = began.globalY;
            updateCurrentPath(began.globalX, began.globalY);

            _paths[_currentEntityID].push(new Point(began.globalX, began.globalY));

        }

        if(rightClickEnded){

            removeChild(_activeSegmentOne);
            removeChild(_activeSegmentTwo);
            _paths[_currentEntityID].push(new Point(_enemyCorePosition.x, _enemyCorePosition.y));

            for(var i:int = 0; i < _temporaryLines.length; i++){

                removeChild(_temporaryLines[i]);
                _temporaryLines[i].dispose();

            }

            drawPath(_currentEntityID);
            Game.getInstance().removeEventListener(TouchEvent.TOUCH, onTouch);

            _onPathFinished(_paths[_currentEntityID]);

        }

    }

    private function updateCurrentPath(posX:Number, posY:Number):void {

        _activeSegmentOne.rotation = Math.atan2(posY - _activeSegmentOne.y, posX - _activeSegmentOne.x);
        _activeSegmentOne.scaleX = Math.sqrt((posX - _activeSegmentOne.x) * (posX - _activeSegmentOne.x) + ( _activeSegmentOne.y - posY) * ( _activeSegmentOne.y - posY));

        _activeSegmentTwo.rotation = Math.atan2(posY - _activeSegmentTwo.y, posX - _activeSegmentTwo.x);
        _activeSegmentTwo.scaleX = Math.sqrt((posX - _activeSegmentTwo.x) * (posX - _activeSegmentTwo.x) + ( _activeSegmentTwo.y - posY) * ( _activeSegmentTwo.y - posY));


    }
























    public static function getInstance():HudLayer {

        if(!_instance){
            _instance = new HudLayer();
        }

        return _instance;

    }
}
}
