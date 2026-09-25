package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.map.RegionLibrary;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.ui.BaseSimpleText;
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   
   public class InfoPane extends Sprite
   {
      
      public static const WIDTH:int = 134;
      
      public static const HEIGHT:int = 120;
      
      private static const CSS_TEXT:String = ".in { margin-left:10px; text-indent: -10px; }";
      
      private var meMap_:MEMap;
      
      private var rectText_:BaseSimpleText;
      
      private var typeText_:BaseSimpleText;
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(3552822,1);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      public function InfoPane(param1:MEMap)
      {
         super();
         this.meMap_ = param1;
         this.drawBackground();
         this.rectText_ = new BaseSimpleText(12,16777215,false,WIDTH - 10,0);
         this.rectText_.filters = [new DropShadowFilter(0,0,0)];
         this.rectText_.y = 4;
         this.rectText_.x = 4;
         addChild(this.rectText_);
         this.typeText_ = new BaseSimpleText(12,16777215,false,WIDTH - 10,0);
         this.typeText_.wordWrap = true;
         this.typeText_.filters = [new DropShadowFilter(0,0,0)];
         this.typeText_.x = 4;
         this.typeText_.y = 36;
         addChild(this.typeText_);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Rectangle = this.meMap_.mouseRectT();
         this.rectText_.text = "Position: " + _loc2_.x + ", " + _loc2_.y;
         if(_loc2_.width > 1 || _loc2_.height > 1)
         {
            this.rectText_.text += "\nRect: " + _loc2_.width + ", " + _loc2_.height;
         }
         this.rectText_.useTextDimensions();
         var _loc3_:METile = this.meMap_.getTile(_loc2_.x,_loc2_.y);
         var _loc4_:Vector.<int> = _loc3_ == null ? Layer.EMPTY_TILE : _loc3_.types_;
         var _loc5_:String = _loc4_[Layer.GROUND] == -1 ? "None" : GroundLibrary.getIdFromType(_loc4_[Layer.GROUND]);
         var _loc6_:String = _loc4_[Layer.OBJECT] == -1 ? "None" : ObjectLibrary.getIdFromType(_loc4_[Layer.OBJECT]);
         var _loc7_:String = _loc4_[Layer.REGION] == -1 ? "None" : RegionLibrary.getIdFromType(_loc4_[Layer.REGION]);
         this.typeText_.htmlText = "<span class=\'in\'>" + "Ground: " + _loc5_ + "\nObject: " + _loc6_ + (_loc3_ == null || _loc3_.objName_ == null ? "" : " (" + _loc3_.objName_ + ")") + "\nRegion: " + _loc7_ + "</span>";
         this.typeText_.useTextDimensions();
      }
      
      private function drawBackground() : void
      {
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,[1,1,1,1],this.path_);
         graphics.drawGraphicsData(this.graphicsData_);
      }
   }
}

