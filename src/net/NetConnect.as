package net {

import flash.events.NetStatusEvent;
import flash.net.GroupSpecifier;
import flash.net.NetConnection;
import flash.net.NetGroup;

import starling.events.EventDispatcher;

public class NetConnect extends EventDispatcher{

    public static const PLAYER_FOUND:String = "playerFound";
    public static const ENTITY_ADDED:String = "entityAdded";
    public static const TURN_ENDED:String = "turnEnded";
    public static const UPDATE_ENTITY_DATA:String = "updateEntityData";

    private const SERVER:String = "rtmfp://p2p.rtmfp.net/";
    private const DEVKEY:String = "cde41fe05bb01817e82e5398-2ab5d983d09f";
    private var _nc:NetConnection;
    private var _nearId:String;
    private var _farId:String;
    private var _sequence:uint = 0;
    private var _netGroup:NetGroup;
    private var _user:String;
    private var _connected:Boolean = false;

    // Custom Server Code
    private var _serverConnect:ServerConnect = new ServerConnect();

    public function NetConnect() {

        _nc = new NetConnection();
        _nc.addEventListener(NetStatusEvent.NET_STATUS,netStatus);
        _nc.connect(SERVER + DEVKEY);

    }

    private function netStatus(event:NetStatusEvent):void{

        switch(event.info.code){
            case "NetConnection.Connect.Success":
                setupGroup();
                break;

            case "NetGroup.Connect.Success":
                _connected = true;
                break;

            case "NetGroup.Neighbor.Connect":
                _serverConnect.startMatch(_serverConnect.getGroupSpec());
                _nearId = _nc.nearID;
                _farId = event.info.peerID;
                sendMessage(PLAYER_FOUND, _farId);
                break;

            case "NetGroup.Neighbor.Disconnect":
                _serverConnect.endMatch(_serverConnect.getGroupSpec());
                break;

            case "NetGroup.Posting.Notify":
                receiveMessage(event.info.message);
                break;
        }

        trace(event.info.code);

    }

    private function setupGroup():void{

        var id:int = Math.random() * int.MAX_VALUE;
        var playerName:String = "player" + id;

        _serverConnect.match(playerName, function(data:Object):void {
            trace("[ServerConnect] GroupSpecifier: " + _serverConnect.getGroupSpec());
            trace("[ServerConnect] Player slot: " + _serverConnect.getPlayerNumber());

            var groupSpec:GroupSpecifier = new GroupSpecifier(_serverConnect.getGroupSpec());
            groupSpec.serverChannelEnabled = true;
            groupSpec.postingEnabled = true;

            _netGroup = new NetGroup(_nc,groupSpec.groupspecWithAuthorizations());
            _netGroup.addEventListener(NetStatusEvent.NET_STATUS,netStatus);

            _user = "user" + _serverConnect.getPlayerNumber();
        });



    }

    public function sendMessage(type:String, data:Object):void {

        var message:Object = new Object();
        message.sender = _netGroup.convertPeerIDToGroupAddress(_nc.nearID);
        message.sequence = _sequence++;
        message.type = type;
        message.data = data;
        _netGroup.post(message);

    }

    private function receiveMessage(message:Object):void{

        dispatchEventWith("messageReceived", false, message);

    }

    public function getPlayerNumber():int {
        return _serverConnect.getPlayerNumber();
    }












}
}
