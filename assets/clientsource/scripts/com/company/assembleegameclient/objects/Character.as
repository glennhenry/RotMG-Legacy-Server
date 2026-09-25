package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.sound.SoundEffectLibrary;
   
   public class Character extends GameObject
   {
      
      public var hurtSound_:String;
      
      public var deathSound_:String;
      
      public function Character(param1:XML)
      {
         super(param1);
         this.hurtSound_ = param1.hasOwnProperty("HitSound") ? String(param1.HitSound) : "monster/default_hit";
         SoundEffectLibrary.load(this.hurtSound_);
         this.deathSound_ = param1.hasOwnProperty("DeathSound") ? String(param1.DeathSound) : "monster/default_death";
         SoundEffectLibrary.load(this.deathSound_);
      }
      
      override public function damage(param1:int, param2:int, param3:Vector.<uint>, param4:Boolean, param5:Projectile) : void
      {
         super.damage(param1,param2,param3,param4,param5);
         if(dead_)
         {
            SoundEffectLibrary.play(this.deathSound_);
         }
         else if(Boolean(param5) || param2 > 0)
         {
            SoundEffectLibrary.play(this.hurtSound_);
         }
      }
   }
}

