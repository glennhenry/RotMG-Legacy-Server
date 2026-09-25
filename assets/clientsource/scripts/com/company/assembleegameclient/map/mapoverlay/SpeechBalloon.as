package com.company.assembleegameclient.map.mapoverlay
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsPathCommand;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.ui.model.HUDModel;
   
   public class SpeechBalloon extends Sprite implements IMapOverlayElement
   {
      
      public var go_:GameObject;
      
      public var lifetime_:int;
      
      public var hideable_:Boolean;
      
      public var offset_:Point = new Point();
      
      public var text_:TextField;
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(0,1);
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.lineStyle_,this.backgroundFill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      private var senderName:String;
      
      private var isTrade:Boolean;
      
      private var isGuild:Boolean;
      
      private var startTime_:int = 0;
      
      public function SpeechBalloon(param1:GameObject, param2:String, param3:String, param4:Boolean, param5:Boolean, param6:uint, param7:Number, param8:uint, param9:Number, param10:uint, param11:int, param12:Boolean, param13:Boolean)
      {
         super();
         this.go_ = param1;
         this.senderName = param3;
         this.isTrade = param4;
         this.isGuild = param5;
         this.lifetime_ = param11 * 1000;
         this.hideable_ = param13;
         this.text_ = new TextField();
         this.text_.autoSize = TextFieldAutoSize.LEFT;
         this.text_.embedFonts = true;
         this.text_.width = 150;
         var _loc14_:TextFormat = new TextFormat();
         _loc14_.font = "Myriad Pro";
         _loc14_.size = 14;
         _loc14_.bold = param12;
         _loc14_.color = param10;
         this.text_.defaultTextFormat = _loc14_;
         this.text_.selectable = false;
         this.text_.mouseEnabled = false;
         this.text_.multiline = true;
         this.text_.wordWrap = true;
         this.text_.text = param2;
         addChild(this.text_);
         var _loc15_:int = this.text_.textWidth + 4;
         this.offset_.x = -_loc15_ / 2;
         this.backgroundFill_.color = param6;
         this.backgroundFill_.alpha = param7;
         this.outlineFill_.color = param8;
         this.outlineFill_.alpha = param9;
         graphics.clear();
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(-6,-6,_loc15_ + 12,height + 12,4,[1,1,1,1],this.path_);
         this.path_.commands.splice(6,0,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO,GraphicsPathCommand.LINE_TO);
         var _loc16_:int = height;
         this.path_.data.splice(12,0,_loc15_ / 2 + 8,_loc16_ + 6,_loc15_ / 2,_loc16_ + 18,_loc15_ / 2 - 8,_loc16_ + 6);
         graphics.drawGraphicsData(this.graphicsData_);
         filters = [new DropShadowFilter(0,0,0,1,16,16)];
         this.offset_.y = -height - this.go_.texture_.height * (param1.size_ / 100) * 5 - 2;
         visible = false;
         addEventListener(MouseEvent.RIGHT_CLICK,this.onSpeechBalloonRightClicked);
      }
      
      private function onSpeechBalloonRightClicked(param1:MouseEvent) : void
      {
         var hmod:HUDModel = null;
         var aPlayer:Player = null;
         var e:MouseEvent = param1;
         var playerObjectId:int = this.go_.objectId_;
         try
         {
            hmod = StaticInjectorContext.getInjector().getInstance(HUDModel);
            if(hmod.gameSprite.map.goDict_[playerObjectId] != null && hmod.gameSprite.map.goDict_[playerObjectId] is Player && hmod.gameSprite.map.player_.objectId_ != playerObjectId)
            {
               aPlayer = hmod.gameSprite.map.goDict_[playerObjectId] as Player;
               hmod.gameSprite.addChatPlayerMenu(aPlayer,e.stageX,e.stageY);
            }
            else if(!this.isTrade && this.senderName != null && this.senderName != "" && hmod.gameSprite.map.player_.name_ != this.senderName)
            {
               hmod.gameSprite.addChatPlayerMenu(null,e.stageX,e.stageY,this.senderName,this.isGuild);
            }
            else if(this.isTrade && this.senderName != null && this.senderName != "" && hmod.gameSprite.map.player_.name_ != this.senderName)
            {
               hmod.gameSprite.addChatPlayerMenu(null,e.stageX,e.stageY,this.senderName,false,true);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function draw(param1:Camera, param2:int) : Boolean
      {
         if(this.startTime_ == 0)
         {
            this.startTime_ = param2;
         }
         var _loc3_:int = param2 - this.startTime_;
         if(_loc3_ > this.lifetime_ || this.go_ != null && this.go_.map_ == null)
         {
            return false;
         }
         if(this.go_ == null || !this.go_.drawn_)
         {
            visible = false;
            return true;
         }
         if(this.hideable_ && !Parameters.data_.textBubbles)
         {
            visible = false;
            return true;
         }
         visible = true;
         x = int(this.go_.posS_[0] + this.offset_.x);
         y = int(this.go_.posS_[1] + this.offset_.y);
         return true;
      }
      
      public function getGameObject() : GameObject
      {
         return this.go_;
      }
      
      public function dispose() : void
      {
         parent.removeChild(this);
      }
   }
}

