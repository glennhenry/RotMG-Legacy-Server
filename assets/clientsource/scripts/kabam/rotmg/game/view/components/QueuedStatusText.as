package kabam.rotmg.game.view.components
{
   import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
   import com.company.assembleegameclient.objects.GameObject;
   import kabam.rotmg.text.view.stringBuilder.StringBuilder;
   
   public class QueuedStatusText extends CharacterStatusText
   {
      
      public var list:QueuedStatusTextList;
      
      public var next:QueuedStatusText;
      
      public var stringBuilder:StringBuilder;
      
      public function QueuedStatusText(param1:GameObject, param2:StringBuilder, param3:uint, param4:int, param5:int = 0)
      {
         this.stringBuilder = param2;
         super(param1,param3,param4,param5);
         setStringBuilder(param2);
      }
      
      override public function dispose() : void
      {
         this.list.shift();
      }
   }
}

