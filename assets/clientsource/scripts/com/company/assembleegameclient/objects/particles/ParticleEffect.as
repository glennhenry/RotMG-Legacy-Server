package com.company.assembleegameclient.objects.particles
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.objects.GameObject;
   import flash.display.IGraphicsData;
   
   public class ParticleEffect extends GameObject
   {
      
      public var reducedDrawEnabled:Boolean;
      
      public function ParticleEffect()
      {
         super(null);
         objectId_ = getNextFakeObjectId();
         hasShadow_ = false;
         this.reducedDrawEnabled = false;
      }
      
      public static function fromProps(param1:EffectProperties, param2:GameObject) : ParticleEffect
      {
         switch(param1.id)
         {
            case "Healing":
               return new HealingEffect(param2);
            case "Fountain":
               return new FountainEffect(param2);
            case "Gas":
               return new GasEffect(param2,param1);
            case "Vent":
               return new VentEffect(param2);
            case "Bubbles":
               return new BubbleEffect(param2,param1);
            case "XMLEffect":
               return new XMLEffect(param2,param1);
            case "CustomParticles":
               return ParticleGenerator.attachParticleGenerator(param1,param2);
            default:
               return null;
         }
      }
      
      override public function update(param1:int, param2:int) : Boolean
      {
         if(this.reducedDrawEnabled)
         {
            return this.runEasyRendering(param1,param2);
         }
         return this.runNormalRendering(param1,param2);
      }
      
      public function runNormalRendering(param1:int, param2:int) : Boolean
      {
         return false;
      }
      
      public function runEasyRendering(param1:int, param2:int) : Boolean
      {
         return false;
      }
      
      override public function draw(param1:Vector.<IGraphicsData>, param2:Camera, param3:int) : void
      {
      }
   }
}

