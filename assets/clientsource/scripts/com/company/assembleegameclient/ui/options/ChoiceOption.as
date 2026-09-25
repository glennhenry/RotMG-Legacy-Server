package com.company.assembleegameclient.ui.options
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.events.Event;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class ChoiceOption extends BaseOption
   {
      
      private var callback_:Function;
      
      private var choiceBox_:ChoiceBox;
      
      public function ChoiceOption(param1:String, param2:Vector.<StringBuilder>, param3:Array, param4:String, param5:String, param6:Function, param7:Number = 16777215)
      {
         super(param1,param4,param5);
         desc_.setColor(param7);
         tooltip_.tipText_.setColor(param7);
         this.callback_ = param6;
         this.choiceBox_ = new ChoiceBox(param2,param3,Parameters.data_[paramName_],param7);
         this.choiceBox_.addEventListener(Event.CHANGE,this.onChange);
         addChild(this.choiceBox_);
      }
      
      override public function refresh() : void
      {
         this.choiceBox_.setValue(Parameters.data_[paramName_]);
      }
      
      public function refreshNoCallback() : void
      {
         this.choiceBox_.setValue(Parameters.data_[paramName_],false);
      }
      
      private function onChange(param1:Event) : void
      {
         Parameters.data_[paramName_] = this.choiceBox_.value();
         if(this.callback_ != null)
         {
            this.callback_();
         }
         Parameters.save();
      }
   }
}

