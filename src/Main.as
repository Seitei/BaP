package {

import flash.display.Sprite;

import starling.core.Starling;

[SWF(backgroundColor='0x999999', width="700", height="700", frameRate="60")]
public class Main extends Sprite {

    private var _starling:Starling;

    public function Main() {

        _starling = new Starling(Game, stage);
        _starling.start();
        _starling.showStats = true;
    }
}
}
