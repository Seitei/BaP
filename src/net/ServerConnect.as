package net {

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Timer;

public class ServerConnect extends EventDispatcher {

    private var _loader:URLLoader = new URLLoader();
    private var _completeCallback:Function;
    private var _debug:Boolean = false;
    private const HOST:String = "http://gb-dk40gm4e.rhcloud.com";
    //private const HOST:String = "http://gb.local";

    private var _groupSpec:String;
    private var _playerName:String;
    private var _playerNumber:int;
    private var _cancelMatchTimer:Timer = new Timer(4000, 1);

    public function getGroupSpec():String {
        return _groupSpec;
    }

    public function getPlayerName():String {
        return _playerName;
    }

    public function getPlayerNumber():int {
        return _playerNumber;
    }

    public function ServerConnect() {
        _cancelMatchTimer.addEventListener(TimerEvent.TIMER_COMPLETE, cancelMatch);
    }

    private function configureListeners(dispatcher:IEventDispatcher):void {
        dispatcher.addEventListener(Event.COMPLETE, completeHandler);
        dispatcher.addEventListener(Event.OPEN, openHandler);
        dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
        dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
    }

    private function removeListeners(dispatcher:IEventDispatcher):void{
        dispatcher.removeEventListener(Event.COMPLETE, completeHandler);
        dispatcher.removeEventListener(Event.OPEN, openHandler);
        dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
        dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
        dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
    }

    private function completeHandler(event:Event):void {
        URLLoader(event.target).data;
        if(_completeCallback) {
            _completeCallback(JSON.parse(_loader.data));
        }
        log("completeHandler: " + _loader.data);
    }

    private function openHandler(event:Event):void {
        log("openHandler: " + event);
    }

    private function progressHandler(event:ProgressEvent):void {
        log("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
    }

    private function securityErrorHandler(event:SecurityErrorEvent):void {
        log("securityErrorHandler: " + event);
        removeListeners(_loader);
        throw new Error(event.toString());
    }

    private function httpStatusHandler(event:HTTPStatusEvent):void {
        log("httpStatusHandler: " + event);
    }

    private function ioErrorHandler(event:IOErrorEvent):void {
        log("ioErrorHandler: " + event);
        throw new Error(event.toString());
    }

    private function log(message:String):void {
        if(_debug) {
            trace("[ServerConnect]" + message);
        }
    }

    private function call(url:String, completeCallback:Function = null):void {
        _completeCallback = completeCallback;
        configureListeners(_loader);
        var finalUrl:String = HOST + url;
                log("Calling: " + finalUrl);
        var request:URLRequest = new URLRequest(finalUrl);
        try {
            _loader.load(request);
        } catch (error:Error) {
            throw new Error("Unable to load requested document.");
        }
    }

    private function cancelMatch(evt:TimerEvent):void {
        resetMatch(_groupSpec, _playerName);
    }

    public function match(playerName:String, completeCallback:Function):void {
        call("/match/" + playerName, function(data:Object){
            _groupSpec = data.key.toString();
            _playerNumber = parseInt(data.player_number.toString(), 10);
            _playerName = playerName;
            if(_playerNumber == 2) {
                _cancelMatchTimer.reset();
                _cancelMatchTimer.start();
            }
            if(completeCallback) {
                completeCallback(data);
            }
        });
    }

    public function startMatch(groupSpec:String, completeCallback:Function = null):void {
        _cancelMatchTimer.stop();
        call("/match/start/" + groupSpec, completeCallback);
    }

    public function endMatch(groupSpec:String, completeCallback:Function = null):void {
        call("/match/end/" + groupSpec, completeCallback);
    }

    public function resetMatch(groupSpec:String, playerName:String, completeCallback:Function = null):void {
        _playerNumber = 1;
        call("/match/reset/" + groupSpec + "/" + playerName, completeCallback);
    }
}
}
