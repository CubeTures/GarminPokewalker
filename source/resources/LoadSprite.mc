import Toybox.Lang;
using Toybox.Graphics;
using Toybox.WatchUi;
using Models;

module Resources {
    function loadFemaleSprite(sid as Number) as Graphics.BitmapType {
        return dummySprite();
    }

    function loadFormSprite(sid as Number, form as Number) as Graphics.BitmapType {
        return dummySprite();
    }

    function loadBasicSprite(sid as Number) as Graphics.BitmapType {
        return dummySprite();
    }

    function loadRightSprite(sid as Number) as Graphics.BitmapType {
        return dummySprite();
    }

    function dummySprite() as Graphics.BitmapType {
        return WatchUi.loadResource(Rez.Drawables.sprites_1) as Graphics.BitmapType;
    }
}
