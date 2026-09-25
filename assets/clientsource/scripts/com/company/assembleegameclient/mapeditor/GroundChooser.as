package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.util.MoreStringUtil;
   
   internal class GroundChooser extends Chooser
   {
      
      public function GroundChooser()
      {
         var _loc1_:String = null;
         var _loc3_:int = 0;
         var _loc4_:GroundElement = null;
         super(Layer.GROUND);
         var _loc2_:Vector.<String> = new Vector.<String>();
         for(_loc1_ in GroundLibrary.idToType_)
         {
            _loc2_.push(_loc1_);
         }
         _loc2_.sort(MoreStringUtil.cmp);
         for each(_loc1_ in _loc2_)
         {
            _loc3_ = int(GroundLibrary.idToType_[_loc1_]);
            _loc4_ = new GroundElement(GroundLibrary.xmlLibrary_[_loc3_]);
            addElement(_loc4_);
         }
      }
   }
}

