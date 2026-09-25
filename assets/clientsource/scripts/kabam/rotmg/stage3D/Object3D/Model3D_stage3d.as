package kabam.rotmg.stage3D.Object3D
{
   import flash.display3D.Context3D;
   import flash.display3D.VertexBuffer3D;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class Model3D_stage3d
   {
      
      public var name:String;
      
      public var groups:Vector.<OBJGroup>;
      
      public var vertexBuffer:VertexBuffer3D;
      
      protected var _materials:Dictionary;
      
      protected var _tupleIndex:uint;
      
      protected var _tupleIndices:Dictionary;
      
      protected var _vertices:Vector.<Number>;
      
      public function Model3D_stage3d()
      {
         super();
         this.groups = new Vector.<OBJGroup>();
         this._materials = new Dictionary();
         this._vertices = new Vector.<Number>();
      }
      
      public function dispose() : void
      {
         var _loc1_:OBJGroup = null;
         for each(_loc1_ in this.groups)
         {
            _loc1_.dispose();
         }
         this.groups.length = 0;
         if(this.vertexBuffer !== null)
         {
            this.vertexBuffer.dispose();
            this.vertexBuffer = null;
         }
         this._vertices.length = 0;
         this._tupleIndex = 0;
         this._tupleIndices = new Dictionary();
      }
      
      public function CreatBuffer(param1:Context3D) : void
      {
         var _loc2_:OBJGroup = null;
         for each(_loc2_ in this.groups)
         {
            if(_loc2_._indices.length > 0)
            {
               _loc2_.indexBuffer = param1.createIndexBuffer(_loc2_._indices.length);
               _loc2_.indexBuffer.uploadFromVector(_loc2_._indices,0,_loc2_._indices.length);
               _loc2_._faces = null;
            }
         }
         this.vertexBuffer = param1.createVertexBuffer(this._vertices.length / 8,8);
         this.vertexBuffer.uploadFromVector(this._vertices,0,this._vertices.length / 8);
      }
      
      public function readBytes(param1:ByteArray) : void
      {
         var _loc2_:Vector.<String> = null;
         var _loc3_:OBJGroup = null;
         var _loc10_:String = null;
         var _loc11_:Array = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         this.dispose();
         var _loc4_:String = "";
         var _loc5_:Vector.<Number> = new Vector.<Number>();
         var _loc6_:Vector.<Number> = new Vector.<Number>();
         var _loc7_:Vector.<Number> = new Vector.<Number>();
         param1.position = 0;
         var _loc8_:String = param1.readUTFBytes(param1.bytesAvailable);
         var _loc9_:Array = _loc8_.split(/[\r\n]+/);
         for each(_loc10_ in _loc9_)
         {
            _loc10_ = _loc10_.replace(/^\s*|\s*$/g,"");
            if(_loc10_ == "" || _loc10_.charAt(0) === "#")
            {
               continue;
            }
            _loc11_ = _loc10_.split(/\s+/);
            switch(_loc11_[0].toLowerCase())
            {
               case "v":
                  _loc5_.push(parseFloat(_loc11_[1]),parseFloat(_loc11_[2]),parseFloat(_loc11_[3]));
                  break;
               case "vn":
                  _loc6_.push(parseFloat(_loc11_[1]),parseFloat(_loc11_[2]),parseFloat(_loc11_[3]));
                  break;
               case "vt":
                  _loc7_.push(parseFloat(_loc11_[1]),1 - parseFloat(_loc11_[2]));
                  break;
               case "f":
                  _loc2_ = new Vector.<String>();
                  for each(_loc12_ in _loc11_.slice(1))
                  {
                     _loc2_.push(_loc12_);
                  }
                  if(_loc3_ === null)
                  {
                     _loc3_ = new OBJGroup(null,_loc4_);
                     this.groups.push(_loc3_);
                  }
                  _loc3_._faces.push(_loc2_);
                  break;
               case "g":
                  _loc3_ = new OBJGroup(_loc11_[1],_loc4_);
                  this.groups.push(_loc3_);
                  break;
               case "o":
                  this.name = _loc11_[1];
                  break;
               case "usemtl":
                  _loc4_ = _loc11_[1];
                  if(_loc3_ !== null)
                  {
                     _loc3_.materialName = _loc4_;
                  }
            }
         }
         for each(_loc3_ in this.groups)
         {
            _loc3_._indices.length = 0;
            for each(_loc2_ in _loc3_._faces)
            {
               _loc13_ = _loc2_.length - 1;
               _loc14_ = 1;
               while(_loc14_ < _loc13_)
               {
                  _loc3_._indices.push(this.mergeTuple(_loc2_[_loc14_],_loc5_,_loc6_,_loc7_));
                  _loc3_._indices.push(this.mergeTuple(_loc2_[0],_loc5_,_loc6_,_loc7_));
                  _loc3_._indices.push(this.mergeTuple(_loc2_[_loc14_ + 1],_loc5_,_loc6_,_loc7_));
                  _loc14_++;
               }
            }
            _loc3_._faces = null;
         }
         this._tupleIndex = 0;
         this._tupleIndices = null;
      }
      
      protected function mergeTuple(param1:String, param2:Vector.<Number>, param3:Vector.<Number>, param4:Vector.<Number>) : uint
      {
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         if(this._tupleIndices[param1] !== undefined)
         {
            return this._tupleIndices[param1];
         }
         _loc5_ = param1.split("/");
         _loc6_ = parseInt(_loc5_[0],10) - 1;
         this._vertices.push(param2[_loc6_ * 3 + 0],param2[_loc6_ * 3 + 1],param2[_loc6_ * 3 + 2]);
         if(_loc5_.length > 2 && _loc5_[2].length > 0)
         {
            _loc6_ = parseInt(_loc5_[2],10) - 1;
            this._vertices.push(param3[_loc6_ * 3 + 0],param3[_loc6_ * 3 + 1],param3[_loc6_ * 3 + 2]);
         }
         else
         {
            this._vertices.push(0,0,0);
         }
         if(_loc5_.length > 1 && _loc5_[1].length > 0)
         {
            _loc6_ = parseInt(_loc5_[1],10) - 1;
            this._vertices.push(param4[_loc6_ * 2 + 0],param4[_loc6_ * 2 + 1]);
         }
         else
         {
            this._vertices.push(0,0);
         }
         return this._tupleIndices[param1] = this._tupleIndex++;
      }
   }
}

