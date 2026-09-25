package com.company.assembleegameclient.tutorial
{
   import com.company.assembleegameclient.ui.DeprecatedTextButton;
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
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class TutorialMessage extends Sprite
   {
      
      public static const BORDER:int = 8;
      
      private var tutorial_:Tutorial;
      
      private var rect_:Rectangle;
      
      private var messageText_:TextFieldDisplayConcrete;
      
      private var nextButton_:DeprecatedTextButton = null;
      
      private var startTime_:int;
      
      private var fill_:GraphicsSolidFill = new GraphicsSolidFill(3552822,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,new GraphicsSolidFill(16777215));
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.lineStyle_,this.fill_,this.path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      public function TutorialMessage(param1:Tutorial, param2:String, param3:Boolean, param4:Rectangle)
      {
         super();
         this.tutorial_ = param1;
         this.rect_ = param4.clone();
         x = this.rect_.x;
         y = this.rect_.y;
         this.rect_.x = 0;
         this.rect_.y = 0;
         this.messageText_ = new TextFieldDisplayConcrete().setSize(15).setColor(16777215).setTextWidth(this.rect_.width - 4 * BORDER);
         this.messageText_.setStringBuilder(new LineBuilder().setParams(param2));
         this.messageText_.x = 2 * BORDER;
         this.messageText_.y = 2 * BORDER;
         if(param3)
         {
            this.nextButton_ = new DeprecatedTextButton(18,"Next");
            this.nextButton_.addEventListener(MouseEvent.CLICK,this.onNextButton);
            this.nextButton_.x = this.rect_.width - this.nextButton_.width - 20;
            this.nextButton_.y = this.rect_.height - this.nextButton_.height - 10;
         }
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function drawRect() : void
      {
         var _loc1_:Number = Math.min(1,0.1 + 0.9 * (getTimer() - this.startTime_) / 200);
         if(_loc1_ == 1)
         {
            addChild(this.messageText_);
            if(this.nextButton_ != null)
            {
               addChild(this.nextButton_);
            }
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
         var _loc2_:Rectangle = this.rect_.clone();
         _loc2_.inflate(-(1 - _loc1_) * this.rect_.width / 2,-(1 - _loc1_) * this.rect_.height / 2);
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(_loc2_.x,_loc2_.y,_loc2_.width,_loc2_.height,4,[1,1,1,1],this.path_);
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData_);
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         this.startTime_ = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.drawRect();
      }
      
      private function onNextButton(param1:MouseEvent) : void
      {
         this.tutorial_.doneAction(Tutorial.NEXT_ACTION);
      }
   }
}

