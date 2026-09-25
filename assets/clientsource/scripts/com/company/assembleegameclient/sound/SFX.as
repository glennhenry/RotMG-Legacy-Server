package com.company.assembleegameclient.sound
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.googleanalytics.GA;
   import flash.media.SoundTransform;
   
   public class SFX
   {
      
      private static var sfxTrans_:SoundTransform;
      
      public function SFX()
      {
         super();
      }
      
      public static function load() : void
      {
         sfxTrans_ = new SoundTransform(Parameters.data_.playSFX ? 1 : 0);
      }
      
      public static function setPlaySFX(param1:Boolean) : void
      {
         GA.global().trackEvent("sound",param1 ? "soundOn" : "soundOff");
         Parameters.data_.playSFX = param1;
         Parameters.save();
         SoundEffectLibrary.updateTransform();
      }
      
      public static function setSFXVolume(param1:Number) : void
      {
         Parameters.data_.SFXVolume = param1;
         Parameters.save();
         SoundEffectLibrary.updateVolume(param1);
      }
   }
}

