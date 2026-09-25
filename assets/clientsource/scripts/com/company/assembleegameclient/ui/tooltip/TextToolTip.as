package com.company.assembleegameclient.ui.tooltip
{
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.text.view.TextFieldDisplayConcrete;
   import kabam.rotmg.text.view.stringBuilder.LineBuilder;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class TextToolTip extends ToolTip
   {
      
      public var titleText_:TextFieldDisplayConcrete;
      
      public var tipText_:TextFieldDisplayConcrete;
      
      public function TextToolTip(param1:uint, param2:uint, param3:String, param4:String, param5:int, param6:Object = null)
      {
         super(param1,1,param2,1);
         if(param3 != null)
         {
            this.titleText_ = new TextFieldDisplayConcrete().setSize(20).setColor(16777215);
            this.configureTextFieldDisplayAndAddChild(this.titleText_,param5,param3);
         }
         if(param4 != null)
         {
            this.tipText_ = new TextFieldDisplayConcrete().setSize(14).setColor(11776947);
            this.configureTextFieldDisplayAndAddChild(this.tipText_,param5,param4,param6);
         }
      }
      
      override protected function alignUI() : void
      {
         this.tipText_.y = this.titleText_ ? this.titleText_.height + 8 : 0;
      }
      
      public function configureTextFieldDisplayAndAddChild(param1:TextFieldDisplayConcrete, param2:int, param3:String, param4:Object = null) : void
      {
         param1.setAutoSize(TextFieldAutoSize.LEFT);
         param1.setWordWrap(true).setTextWidth(param2);
         param1.setStringBuilder(new LineBuilder().setParams(param3,param4));
         param1.filters = [new DropShadowFilter(0,0,0)];
         waiter.push(param1.textChanged);
         addChild(param1);
      }
      
      public function setTitle(param1:StringBuilder) : void
      {
         this.titleText_.setStringBuilder(param1);
         draw();
      }
      
      public function setText(param1:StringBuilder) : void
      {
         this.tipText_.setStringBuilder(param1);
         draw();
      }
   }
}

