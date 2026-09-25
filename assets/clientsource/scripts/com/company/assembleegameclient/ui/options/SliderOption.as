package com.company.assembleegameclient.ui.options
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.events.Event;
   
   public class SliderOption extends BaseOption
   {
      
      private var sliderBar:VolumeSliderBar;
      
      private var disabled_:Boolean;
      
      private var callbackFunc:Function;
      
      public function SliderOption(param1:String, param2:Function = null, param3:Boolean = false)
      {
         super(param1,"","");
         this.sliderBar = new VolumeSliderBar(Parameters.data_[paramName_]);
         this.sliderBar.addEventListener(Event.CHANGE,this.onChange);
         this.callbackFunc = param2;
         addChild(this.sliderBar);
         this.setDisabled(param3);
      }
      
      public function setDisabled(param1:Boolean) : void
      {
         this.disabled_ = param1;
         mouseEnabled = !this.disabled_;
         mouseChildren = !this.disabled_;
      }
      
      override public function refresh() : void
      {
         this.sliderBar.currentVolume = Parameters.data_[paramName_];
      }
      
      private function onChange(param1:Event) : void
      {
         Parameters.data_[paramName_] = this.sliderBar.currentVolume;
         if(this.callbackFunc != null)
         {
            this.callbackFunc(this.sliderBar.currentVolume);
         }
         Parameters.save();
      }
   }
}

