/**
/////////////////////////////////////////////////////////////////////////////////////
FPS Checking Class for AS3
/////////////////////////////////////////////////////////////////////////////////////
Developer: papervision3d Example
AS3 Converting: LENA INVERSE (2nd07@hanmail.net)
Last Modify: 2007.05.16 Wednesday PM 2:27
Version: 1.0.0
-------------------------------------------------------------------------------------
<usage>
import as3.util.FPSCheck
stage.addChild(new FPSCheck());
/////////////////////////////////////////////////////////////////////////////////////
Modifer: Seo Heeman(scaryama@hotmail.com)
Last Modify: 2007-11-28
Version: 1.0.1
-------------------------------------------------------------------------------------
속도 최적화
-MovieClip 에서 Sprite & Shape 으로 교체, enterFrame 로직 최적화
클레스 독립화
-as3.text.Text 제거
스피드메타 디자인 변경
-불필요한 ui제거, 크기최소화, 테마변경
오차제거
-secondTime의 오차 제거
-------------------------------------------------------------------------------------
Last Modify: 2008-10-15
Version: 1.0.2
유연성
타입유형 정의
/////////////////////////////////////////////////////////////////////////////////////
**/
package orpheus.utils {
        import flash.display.Sprite;
        import flash.display.Shape;
        import flash.events.Event;
        import flash.utils.getTimer;
        import flash.text.TextField;
        import flash.text.TextFormat;
        import flash.display.Graphics;
        public final class FPSCheck extends Sprite{
                private var prevFrameTime :Number = getTimer();
                private var prevSecondTime :Number = getTimer();
                private var frames :Number = 0;
                private var tf:TextField = new TextField();
                private var format:TextFormat = new TextFormat();
                private var iBar:Shape = new Shape();
                public function FPSCheck(){
                        initFont();
                        initBar();
                        addChild(iBar);
                        addChild(tf);
                        addEventListener(Event.ADDED_TO_STAGE, onAdded );
                        addEventListener(Event.REMOVED_FROM_STAGE, onRemoved );
                }

                private function onAdded( event: Event ): void{
                        stage.addEventListener( Event.ENTER_FRAME, enterFrame );
                }

                private function onRemoved( event: Event ): void
                {
                        stage.removeEventListener( Event.ENTER_FRAME, enterFrame );
                }
                private function initFont():void{
                        format.font="_sans";
                        format.size=9;
                        format.color="0xffffff";
                        tf.defaultTextFormat=format;
                        tf.y=-4;
                        tf.selectable = false;
                        tf.text =" wait...";
                }
                private function initBar():void{
                        var g:Graphics=iBar.graphics;
                        g.beginFill(0x88bbff);
                        g.drawRect(0,0,100,2);
                        g.beginFill(0x006688);
                        g.drawRect(0,2,100,5);
                        g.beginFill(0xffffff);
                        g.drawRect(100,0,1,7);
                        g.endFill();
                }
                private function enterFrame(e:Event):void{
                        var time:int = getTimer();
                        var frameTime:int = time - prevFrameTime;
                        var secondTime:int = time - prevSecondTime;
                        var divTime:int=secondTime-1000;
                        if(divTime >= 0) {
                                prevSecondTime = time-divTime;
                                display();
                                frames = 0;
                        }else{
                                frames++;
                        }
                        prevFrameTime = time;
                        iBar.width -= (iBar.width - (frameTime<<2))>>2;
                }
                private function display():void{
                        tf.text = frames + " FPS";
                }
        }
}