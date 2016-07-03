/**
 * Created by leandro on 2016-06-23.
 */
package net {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.HTTPStatusEvent;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

public class ServerConnect extends EventDispatcher {

    private var _loader:URLLoader = new URLLoader();
    private var _completeCallback:Function;
    private var _debug:Boolean = false;

    public function ServerConnect() {

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
            _completeCallback(_loader.data);
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

    public function match(key:String, completeCallback:Function):void {
        _completeCallback = completeCallback;
        configureListeners(_loader);
        var url:String = "http://gb-dk40gm4e.rhcloud.com/match/"+key;
        log("Calling: " + url);
        var request:URLRequest = new URLRequest(url);
        try {
            _loader.load(request);
        } catch (error:Error) {
            throw new Error("Unable to load requested document.");
        }
    }
}
}
