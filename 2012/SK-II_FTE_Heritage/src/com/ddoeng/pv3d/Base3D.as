package com.ddoeng.pv3d 
{
    import flash.display.*;
    import flash.events.*;
    import org.papervision3d.cameras.*;
    import org.papervision3d.render.*;
    import org.papervision3d.scenes.*;
    import org.papervision3d.view.*;
    
    public class Base3D extends flash.display.Sprite
    {
        public function Base3D()
        {
            super();
            this.viewPort = new org.papervision3d.view.Viewport3D();
            this.addChild(this.viewPort);
            this.scene = new org.papervision3d.scenes.Scene3D();
            this.camera = new org.papervision3d.cameras.Camera3D();
            this.camera.z = -500;
            this.camera.zoom = 40;
            this.renderer = new org.papervision3d.render.BasicRenderEngine();
            this.addEventListener(flash.events.Event.ENTER_FRAME, this.onEnter);
            return;
        }

        private function onEnter(e:flash.events.Event):void
        {
            this.renderer.renderScene(this.scene, this.camera, this.viewPort);
            return;
        }

        public var viewPort:org.papervision3d.view.Viewport3D;

        public var scene:org.papervision3d.scenes.Scene3D;

        public var camera:org.papervision3d.cameras.Camera3D;

        public var renderer:org.papervision3d.render.BasicRenderEngine;
    }
}
