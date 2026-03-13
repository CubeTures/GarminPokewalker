import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Timer;

module Visuals {
    class Marquee extends WatchUi.Drawable {
        protected var color as Graphics.ColorType;
        protected var backgroundColor as Graphics.ColorType;
        protected var font as Graphics.FontType;
        protected var speed as Number;

        var offset as Float = 0.0f;
        protected var text as String = "";
        private var textWidth as Number = 0;
        private var needsScroll as Boolean = false;
        private var measured as Boolean = false;
        private var pauseTimer as Timer.Timer;
        private var animating as Boolean = false;

        function initialize(
            options as
                {
                    :identifier as String,
                    :text as String,
                    :color as Graphics.ColorType,
                    :backgroundColor as Graphics.ColorType,
                    :font as Graphics.FontType,
                    :locX as Number,
                    :locY as Number,
                    :width as Number,
                    :height as Number,
                    :speed as Number,
                }
        ) {
            Drawable.initialize(options);

            var optText = options.get(:text);
            text = optText != null ? optText : "";

            var optColor = options.get(:color);
            color =
                optColor != null
                    ? optColor as Graphics.ColorType
                    : Graphics.COLOR_WHITE;

            var optBackgroundColor = options.get(:backgroundColor);
            backgroundColor =
                optBackgroundColor != null
                    ? optBackgroundColor as Graphics.ColorType
                    : Graphics.COLOR_BLACK;

            var optFont = options.get(:font);
            font =
                optFont != null
                    ? optFont as Graphics.FontType
                    : Graphics.FONT_SMALL;

            var optSpeed = options.get(:speed);
            speed = optSpeed != null ? optSpeed : 40;

            pauseTimer = new Timer.Timer();
        }

        function getOffset() as Float {
            return offset;
        }

        function setOffset(value as Float) as Void {
            offset = value;
        }

        function setText(newText as String) as Void {
            if (text != newText) {
                pauseTimer.stop();
                WatchUi.cancelAllAnimations();
                text = newText;
                measured = false;
                offset = 0.0f;
                animating = false;
            }
        }

        function draw(dc as Graphics.Dc) as Void {
            measureText(dc);
            var off = offset.toNumber();

            dc.setClip(locX, locY, width, height);
            dc.setColor(color, backgroundColor);
            dc.drawText(
                locX - off,
                locY,
                font,
                text,
                Graphics.TEXT_JUSTIFY_LEFT
            );
            dc.clearClip();

            if (needsScroll && !animating) {
                beginningPause();
            }
        }

        private function measureText(dc as Graphics.Dc) as Void {
            if (!measured) {
                textWidth = dc.getTextWidthInPixels(text, font);
                needsScroll = textWidth > width;
                measured = true;
            }
        }

        private function beginningPause() as Void {
            animating = true;
            pauseTimer.start(method(:playAnimation), 750, false);
        }

        function playAnimation() as Void {
            var target = (textWidth - width).toFloat();
            var duration = ((target - offset) / speed);
            System.println(
                "Play animation to " + target + " for " + duration + "s"
            );

            WatchUi.animate(
                self,
                :offset,
                WatchUi.ANIM_TYPE_LINEAR,
                offset,
                target,
                duration,
                method(:endingPause)
            );
        }

        function endingPause() as Void {
            pauseTimer.start(method(:resetAnimation), 750, false);
        }

        function resetAnimation() as Void {
            offset = 0.0f;
            animating = false;
            WatchUi.requestUpdate();
        }
    }
}
