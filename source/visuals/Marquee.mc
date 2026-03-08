import Toybox.Lang;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;
using Toybox.Timer;

module Visuals {
    class Marquee {
        protected var text as String;
        protected var color as Graphics.ColorType;
        protected var backgroundColor as Graphics.ColorType;
        protected var font as Graphics.FontType;
        protected var locX as Number;
        protected var locY as Number;
        protected var width as Number;
        protected var height as Number;
        protected var speed as Number;
        protected var pingPong as Boolean;

        private var timer as Timer.Timer;
        private var move as Boolean = false;
        private var forward as Boolean = true;
        private var offset as Number = 0;
        private var textWidth as Number = 0;
        private var spaceWidth as Number = 0;
        private var needsScroll as Boolean = false;
        private var measured as Boolean = false;

        function initialize(
            options as
                {
                    :text as String,
                    :color as Graphics.ColorType,
                    :backgroundColor as Graphics.ColorType,
                    :font as Graphics.FontType,
                    :locX as Number,
                    :locY as Number,
                    :width as Number,
                    :height as Number,
                    :speed as Number,
                    :pingPong as Boolean,
                }
        ) {
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

            var optLocX = options.get(:locX);
            locX = optLocX != null ? optLocX : 0;

            var optLocY = options.get(:locY);
            locY = optLocY != null ? optLocY : 0;

            var optWidth = options.get(:width);
            width = optWidth != null ? optWidth : 0;

            var optHeight = options.get(:height);
            height = optHeight != null ? optHeight : 0;

            var optSpeed = options.get(:speed);
            speed = optSpeed != null ? optSpeed : 2;

            var optPingPong = options.get(:pingPong);
            pingPong = optPingPong != null ? optPingPong : false;

            timer = new Timer.Timer();
        }

        function draw(dc as Graphics.Dc) as Void {
            measureText(dc);
            dc.setClip(locX, locY, width, height);
            dc.setColor(color, backgroundColor);
            dc.drawText(
                locX - offset,
                locY,
                font,
                text,
                Graphics.TEXT_JUSTIFY_LEFT
            );
            if (needsScroll && !pingPong) {
                dc.drawText(
                    locX - offset + textWidth + spaceWidth,
                    locY,
                    font,
                    text,
                    Graphics.TEXT_JUSTIFY_LEFT
                );
            }
            setOffset();
            dc.clearClip();
        }

        private function measureText(dc as Graphics.Dc) as Void {
            if (!measured) {
                textWidth = dc.getTextWidthInPixels(text, font);
                if (!pingPong) {
                    spaceWidth = dc.getTextWidthInPixels("     ", font);
                }
                needsScroll = textWidth > width;
                measured = true;
            }
        }

        private function setOffset() as Void {
            if (needsScroll && move) {
                if (pingPong) {
                    setOffsetPingPong();
                } else {
                    setOffsetCycle();
                }
            }
        }

        private function setOffsetPingPong() as Void {
            if (forward) {
                if (offset + speed >= textWidth - width) {
                    offset = textWidth - width;
                    forward = false;
                    setTimer();
                } else {
                    offset += speed;
                }
            } else {
                if (offset - speed <= 0) {
                    offset = 0;
                    forward = true;
                    setTimer();
                } else {
                    offset -= speed;
                }
            }
        }

        private function setOffsetCycle() as Void {
            if (offset + speed >= textWidth + spaceWidth) {
                offset = 0;
                setTimer();
            } else {
                offset += speed;
            }
        }

        function setText(text as String) as Void {
            if (self.text != text) {
                self.text = text;
                measured = false;
                offset = 0;
                setTimer();
            }
        }

        private function setTimer() as Void {
            move = false;
            timer.start(method(:onTimer), 500, false);
        }

        function onTimer() as Void {
            move = true;
        }
    }
}
