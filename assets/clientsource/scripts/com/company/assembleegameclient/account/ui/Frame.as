package com.company.assembleegameclient.account.ui
{
   import com.company.assembleegameclient.ui.DeprecatedClickableText;
   import com.company.googleanalytics.GA;
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.account.web.view.LabeledField;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   
   public class Frame extends Sprite
   {
      
      private static const INDENT:Number = 17;
      
      public var titleText_:TextFieldDisplayConcrete;
      
      public var leftButton_:DeprecatedClickableText;
      
      public var rightButton_:DeprecatedClickableText;
      
      public var analyticsPageName_:String;
      
      public var textInputFields_:Vector.<TextInputField> = new Vector.<TextInputField>();
      
      public var navigationLinks_:Vector.<DeprecatedClickableText> = new Vector.<DeprecatedClickableText>();
      
      public var w_:int = 288;
      
      public var h_:int = 100;
      
      private var titleFill_:GraphicsSolidFill = new GraphicsSolidFill(5066061,1);
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(3552822,1);
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.outlineFill_);
      
      private var path1_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private var path2_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[this.backgroundFill_,this.path2_,GraphicsUtil.END_FILL,this.titleFill_,this.path1_,GraphicsUtil.END_FILL,this.lineStyle_,this.path2_,GraphicsUtil.END_STROKE];
      
      public function Frame(param1:String, param2:String, param3:String, param4:String = "", param5:int = 288)
      {
         super();
         this.w_ = param5;
         this.titleText_ = new TextFieldDisplayConcrete().setSize(13).setColor(11776947);
         this.titleText_.setStringBuilder(new LineBuilder().setParams(param1));
         this.titleText_.filters = [new DropShadowFilter(0,0,0)];
         this.titleText_.x = 5;
         this.titleText_.y = 3;
         this.titleText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         addChild(this.titleText_);
         this.makeAndAddLeftButton(param2);
         this.makeAndAddRightButton(param3);
         this.analyticsPageName_ = param4;
         filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function makeAndAddLeftButton(param1:String) : void
      {
         this.leftButton_ = new DeprecatedClickableText(18,true,param1);
         if(param1 != "")
         {
            this.leftButton_.buttonMode = true;
            this.leftButton_.x = 109;
            addChild(this.leftButton_);
         }
      }
      
      private function makeAndAddRightButton(param1:String) : void
      {
         this.rightButton_ = new DeprecatedClickableText(18,true,param1);
         if(param1 != "")
         {
            this.rightButton_.buttonMode = true;
            this.rightButton_.x = this.w_ - this.rightButton_.width - 26;
            this.rightButton_.setAutoSize(TextFieldAutoSize.RIGHT);
            addChild(this.rightButton_);
         }
      }
      
      public function addLabeledField(param1:LabeledField) : void
      {
         addChild(param1);
         param1.y = this.h_ - 60;
         param1.x = 17;
         this.h_ += param1.getHeight();
      }
      
      public function addTextInputField(param1:TextInputField) : void
      {
         this.textInputFields_.push(param1);
         addChild(param1);
         param1.y = this.h_ - 60;
         param1.x = 17;
         this.h_ += TextInputField.HEIGHT;
      }
      
      public function addNavigationText(param1:DeprecatedClickableText) : void
      {
         this.navigationLinks_.push(param1);
         param1.x = INDENT;
         addChild(param1);
         this.positionText(param1);
      }
      
      public function addComponent(param1:DisplayObject, param2:int = 8) : void
      {
         addChild(param1);
         param1.y = this.h_ - 66;
         param1.x = param2;
         this.h_ += param1.height;
      }
      
      public function addPlainText(param1:String, param2:Object = null) : void
      {
         var text:TextFieldDisplayConcrete = null;
         var position:Function = null;
         var plainText:String = param1;
         var tokens:Object = param2;
         position = function():void
         {
            positionText(text);
            draw();
         };
         text = new TextFieldDisplayConcrete().setSize(12).setColor(16777215);
         text.setStringBuilder(new LineBuilder().setParams(plainText,tokens));
         text.filters = [new DropShadowFilter(0,0,0)];
         text.textChanged.add(position);
         addChild(text);
      }
      
      protected function positionText(param1:DisplayObject) : void
      {
         param1.y = this.h_ - 66;
         param1.x = INDENT;
         this.h_ += 20;
      }
      
      public function addTitle(param1:String) : void
      {
         var _loc2_:TextFieldDisplayConcrete = new TextFieldDisplayConcrete().setSize(20).setColor(11711154).setBold(true);
         _loc2_.setStringBuilder(new LineBuilder().setParams(param1));
         _loc2_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         addChild(_loc2_);
         _loc2_.y = this.h_ - 60;
         _loc2_.x = 15;
         this.h_ += 40;
      }
      
      public function addCheckBox(param1:CheckBoxField) : void
      {
         addChild(param1);
         param1.y = this.h_ - 66;
         param1.x = INDENT;
         this.h_ += 44;
      }
      
      public function addRadioBox(param1:PaymentMethodRadioButtons) : void
      {
         addChild(param1);
         param1.y = this.h_ - 66;
         param1.x = 18;
         this.h_ += param1.height;
      }
      
      public function addSpace(param1:int) : void
      {
         this.h_ += param1;
      }
      
      public function disable() : void
      {
         var _loc1_:DeprecatedClickableText = null;
         mouseEnabled = false;
         mouseChildren = false;
         for each(_loc1_ in this.navigationLinks_)
         {
            _loc1_.setDefaultColor(11776947);
         }
         this.leftButton_.setDefaultColor(11776947);
         this.rightButton_.setDefaultColor(11776947);
      }
      
      public function enable() : void
      {
         var _loc1_:DeprecatedClickableText = null;
         mouseEnabled = true;
         mouseChildren = true;
         for each(_loc1_ in this.navigationLinks_)
         {
            _loc1_.setDefaultColor(16777215);
         }
         this.leftButton_.setDefaultColor(16777215);
         this.rightButton_.setDefaultColor(16777215);
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         this.draw();
         x = stage.stageWidth / 2 - (this.w_ - 6) / 2;
         y = stage.stageHeight / 2 - height / 2;
         if(this.textInputFields_.length > 0)
         {
            stage.focus = this.textInputFields_[0].inputText_;
         }
         this.analyticsPageName_ && GA.global().trackPageview(this.analyticsPageName_);
      }
      
      protected function draw() : void
      {
         graphics.clear();
         GraphicsUtil.clearPath(this.path1_);
         GraphicsUtil.drawCutEdgeRect(-6,-6,this.w_,20 + 12,4,[1,1,0,0],this.path1_);
         GraphicsUtil.clearPath(this.path2_);
         GraphicsUtil.drawCutEdgeRect(-6,-6,this.w_,this.h_,4,[1,1,1,1],this.path2_);
         this.leftButton_.y = this.h_ - 52;
         this.rightButton_.y = this.h_ - 52;
         graphics.drawGraphicsData(this.graphicsData_);
      }
   }
}

