package com.company.assembleegameclient.sound
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   import kabam.rotmg.application.api.ApplicationSetup;
   import kabam.rotmg.core.StaticInjectorContext;
   
   public class SoundEffectLibrary
   {
      
      private static var urlBase:String;
      
      private static const URL_PATTERN:String = "{URLBASE}/sfx/{NAME}.mp3";
      
      public static var nameMap_:Dictionary = new Dictionary();
      
      private static var activeSfxList_:Dictionary = new Dictionary(true);
      
      public function SoundEffectLibrary()
      {
         super();
      }
      
      public static function load(param1:String) : Sound
      {
         return nameMap_[param1] = nameMap_[param1] || makeSound(param1);
      }
      
      public static function makeSound(param1:String) : Sound
      {
         var _loc2_:Sound = new Sound();
         _loc2_.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         _loc2_.load(makeSoundRequest(param1));
         return _loc2_;
      }
      
      private static function getUrlBase() : String
      {
         var setup:ApplicationSetup = null;
         var base:String = "";
         try
         {
            setup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
            base = setup.getAppEngineUrl(true);
         }
         catch(error:Error)
         {
            base = "localhost";
         }
         return base;
      }
      
      private static function makeSoundRequest(param1:String) : URLRequest
      {
         urlBase = urlBase || getUrlBase();
         var _loc2_:String = URL_PATTERN.replace("{URLBASE}",urlBase).replace("{NAME}",param1);
         return new URLRequest(_loc2_);
      }
      
      public static function play(param1:String, param2:Number = 1, param3:Boolean = true) : void
      {
         var actualVolume:Number = NaN;
         var trans:SoundTransform = null;
         var channel:SoundChannel = null;
         var name:String = param1;
         var volumeMultiplier:Number = param2;
         var isFX:Boolean = param3;
         var sound:Sound = load(name);
         var volume:* = Parameters.data_.SFXVolume * volumeMultiplier;
         try
         {
            actualVolume = Boolean(Parameters.data_.playSFX) && Boolean(isFX) || Boolean(!isFX) && Boolean(Parameters.data_.playPewPew) ? Number(volume) : 0;
            trans = new SoundTransform(actualVolume);
            channel = sound.play(0,0,trans);
            channel.addEventListener(Event.SOUND_COMPLETE,onSoundComplete,false,0,true);
            activeSfxList_[channel] = volume;
         }
         catch(error:Error)
         {
         }
      }
      
      private static function onSoundComplete(param1:Event) : void
      {
         var _loc2_:SoundChannel = param1.target as SoundChannel;
         delete activeSfxList_[_loc2_];
      }
      
      public static function updateVolume(param1:Number) : void
      {
         var _loc2_:SoundChannel = null;
         var _loc3_:SoundTransform = null;
         for each(_loc2_ in activeSfxList_)
         {
            activeSfxList_[_loc2_] = param1;
            _loc3_ = _loc2_.soundTransform;
            _loc3_.volume = Parameters.data_.playSFX ? Number(activeSfxList_[_loc2_]) : 0;
            _loc2_.soundTransform = _loc3_;
         }
      }
      
      public static function updateTransform() : void
      {
         var _loc1_:SoundChannel = null;
         var _loc2_:SoundTransform = null;
         for each(_loc1_ in activeSfxList_)
         {
            _loc2_ = _loc1_.soundTransform;
            _loc2_.volume = Parameters.data_.playSFX ? Number(activeSfxList_[_loc1_]) : 0;
            _loc1_.soundTransform = _loc2_;
         }
      }
      
      public static function onIOError(param1:IOErrorEvent) : void
      {
      }
   }
}

