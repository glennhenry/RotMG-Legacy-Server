package com.company.assembleegameclient.sound
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.googleanalytics.GA;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import kabam.rotmg.application.api.ApplicationSetup;
   import kabam.rotmg.core.StaticInjectorContext;
   
   public class Music
   {
      
      private static var musicVolumeTransform:SoundTransform;
      
      private static var music_:Sound = null;
      
      private static var musicChannel_:SoundChannel = null;
      
      private static var volume:Number = 0.3;
      
      public function Music()
      {
         super();
      }
      
      public static function load() : void
      {
         var _loc1_:ApplicationSetup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
         var _loc2_:String = _loc1_.getAppEngineUrl(true) + "/music/sorc.mp3";
         volume = Parameters.data_.musicVolume;
         musicVolumeTransform = new SoundTransform(Parameters.data_.playMusic ? volume : 0);
         music_ = new Sound();
         music_.load(new URLRequest(_loc2_));
         musicChannel_ = music_.play(0,int.MAX_VALUE,musicVolumeTransform);
      }
      
      public static function setPlayMusic(param1:Boolean) : void
      {
         GA.global().trackEvent("sound",param1 ? "musicOn" : "musicOff");
         Parameters.data_.playMusic = param1;
         Parameters.save();
         musicVolumeTransform.volume = Parameters.data_.playMusic ? volume : 0;
         musicChannel_.soundTransform = musicVolumeTransform;
      }
      
      public static function setMusicVolume(param1:Number) : void
      {
         Parameters.data_.musicVolume = param1;
         Parameters.save();
         if(!Parameters.data_.playMusic)
         {
            return;
         }
         if(musicVolumeTransform != null)
         {
            musicVolumeTransform.volume = param1;
         }
         else
         {
            musicVolumeTransform = new SoundTransform(param1);
         }
         musicChannel_.soundTransform = musicVolumeTransform;
      }
   }
}

