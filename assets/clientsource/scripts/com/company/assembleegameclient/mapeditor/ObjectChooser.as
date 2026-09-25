package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.util.MoreStringUtil;
   
   internal class ObjectChooser extends Chooser
   {
      
      public function ObjectChooser()
      {
         var _loc1_:String = null;
         var _loc3_:int = 0;
         var _loc4_:XML = null;
         var _loc5_:ObjectElement = null;
         super(Layer.OBJECT);
         var _loc2_:Vector.<String> = new Vector.<String>();
         for(_loc1_ in ObjectLibrary.idToType_)
         {
            _loc2_.push(_loc1_);
         }
         _loc2_.sort(MoreStringUtil.cmp);
         for each(_loc1_ in _loc2_)
         {
            _loc3_ = int(ObjectLibrary.idToType_[_loc1_]);
            _loc4_ = ObjectLibrary.xmlLibrary_[_loc3_];
            if(!(_loc4_.hasOwnProperty("Item") || _loc4_.hasOwnProperty("Player") || _loc4_.Class == "Projectile"))
            {
               _loc5_ = new ObjectElement(_loc4_);
               addElement(_loc5_);
            }
         }
      }
   }
}

