package {

import flash.display.Sprite;

import starling.core.Starling;

[SWF(backgroundColor='#1d1d1d', width="750", height="750", frameRate="60")]
public class Main extends Sprite {

    private var _starling:Starling;

    public function Main() {

        _starling = new Starling(Game, stage);
        //_starling = new Starling(Test, stage);
        _starling.antiAliasing = 4;
        _starling.start();
        _starling.showStats = true;

    }
}
}
