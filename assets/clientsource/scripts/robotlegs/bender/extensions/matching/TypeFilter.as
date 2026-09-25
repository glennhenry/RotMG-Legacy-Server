package robotlegs.bender.extensions.matching
{
   import flash.utils.getQualifiedClassName;
   
   public class TypeFilter implements ITypeFilter
   {
      
      protected var _allOfTypes:Vector.<Class>;
      
      protected var _anyOfTypes:Vector.<Class>;
      
      protected var _descriptor:String;
      
      protected var _noneOfTypes:Vector.<Class>;
      
      public function TypeFilter(param1:Vector.<Class>, param2:Vector.<Class>, param3:Vector.<Class>)
      {
         super();
         if(!param1 || !param2 || !param3)
         {
            throw ArgumentError("TypeFilter parameters can not be null");
         }
         this._allOfTypes = param1;
         this._anyOfTypes = param2;
         this._noneOfTypes = param3;
      }
      
      public function get allOfTypes() : Vector.<Class>
      {
         return this._allOfTypes;
      }
      
      public function get anyOfTypes() : Vector.<Class>
      {
         return this._anyOfTypes;
      }
      
      public function get descriptor() : String
      {
         return this._descriptor = this._descriptor || this.createDescriptor();
      }
      
      public function get noneOfTypes() : Vector.<Class>
      {
         return this._noneOfTypes;
      }
      
      public function matches(param1:*) : Boolean
      {
         var _loc2_:uint = this._allOfTypes.length;
         while(_loc2_--)
         {
            if(!(param1 is this._allOfTypes[_loc2_]))
            {
               return false;
            }
         }
         _loc2_ = this._noneOfTypes.length;
         while(_loc2_--)
         {
            if(param1 is this._noneOfTypes[_loc2_])
            {
               return false;
            }
         }
         if(this._anyOfTypes.length == 0 && (this._allOfTypes.length > 0 || this._noneOfTypes.length > 0))
         {
            return true;
         }
         _loc2_ = this._anyOfTypes.length;
         while(_loc2_--)
         {
            if(param1 is this._anyOfTypes[_loc2_])
            {
               return true;
            }
         }
         return false;
      }
      
      protected function alphabetiseCaseInsensitiveFCQNs(param1:Vector.<Class>) : Vector.<String>
      {
         var _loc2_:String = null;
         var _loc3_:Vector.<String> = new Vector.<String>(0);
         var _loc4_:uint = param1.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = getQualifiedClassName(param1[_loc5_]);
            _loc3_[_loc3_.length] = _loc2_;
            _loc5_++;
         }
         _loc3_.sort(this.stringSort);
         return _loc3_;
      }
      
      protected function createDescriptor() : String
      {
         var _loc1_:Vector.<String> = this.alphabetiseCaseInsensitiveFCQNs(this.allOfTypes);
         var _loc2_:Vector.<String> = this.alphabetiseCaseInsensitiveFCQNs(this.anyOfTypes);
         var _loc3_:Vector.<String> = this.alphabetiseCaseInsensitiveFCQNs(this.noneOfTypes);
         return "all of: " + _loc1_.toString() + ", any of: " + _loc2_.toString() + ", none of: " + _loc3_.toString();
      }
      
      protected function stringSort(param1:String, param2:String) : int
      {
         if(param1 < param2)
         {
            return 1;
         }
         return -1;
      }
   }
}

