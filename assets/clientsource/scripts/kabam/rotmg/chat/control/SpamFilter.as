package kabam.rotmg.chat.control
{
   public class SpamFilter
   {
      
      private const filterTable:Array = this.createFilterTable();
      
      private const testPatterns:Array = this.returnTestPatterns();
      
      private var newPatterns:Array;
      
      private var patterns:Array;
      
      private var regex:RegExp;
      
      public function SpamFilter()
      {
         super();
      }
      
      private function createFilterTable() : Array
      {
         var _loc3_:String = null;
         var _loc1_:Array = [];
         var _loc2_:Array = ["Aa","Bb","Cc","Dd","Ee","Ff","Gg","Hh","Ii","Jj","Kk","Ll","Mm","Nn","Oo","Pp","Qq","Rr","Ss","Tt","Uu","Vv","Ww","Xx","Yy","Zz","00","11","22","33","44","55","66","77","88","99"];
         for each(_loc3_ in _loc2_)
         {
            _loc1_[_loc3_.charCodeAt(0)] = _loc3_.charAt(1);
            _loc1_[_loc3_.charCodeAt(1)] = _loc3_.charAt(1);
         }
         return _loc1_;
      }
      
      public function setPatterns(param1:Array) : void
      {
         this.newPatterns = param1;
         this.patterns = this.returnAppropriatePatterns();
         var _loc2_:String = this.patterns.join("|");
         this.regex = new RegExp(_loc2_,"g");
         this.evalAreValuesIdentical();
      }
      
      private function evalAreValuesIdentical() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.testPatterns.length)
         {
            _loc1_++;
         }
      }
      
      public function isSpam(param1:String) : Boolean
      {
         this.regex.lastIndex = 0;
         var _loc2_:String = this.applyFilterOn(param1);
         return this.regex.test(_loc2_);
      }
      
      private function applyFilterOn(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = this.filterTable[param1.charCodeAt(_loc3_)];
            if(_loc4_ !== null)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc2_.join("");
      }
      
      private function returnAppropriatePatterns() : Array
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc1_:uint = 0;
         while(_loc1_ < this.newPatterns.length)
         {
            _loc3_ = "";
            _loc4_ = 0;
            while(_loc4_ < this.newPatterns[_loc1_].length)
            {
               if(this.newPatterns[_loc1_].charAt(_loc4_) != "\'" && this.newPatterns[_loc1_].charAt(_loc4_) != "\"")
               {
                  _loc3_ = _loc3_.concat(this.newPatterns[_loc1_].charAt(_loc4_));
               }
               _loc4_++;
            }
            this.newPatterns[_loc1_] = _loc3_;
            _loc1_++;
         }
         var _loc2_:Array = this.newPatterns;
         _loc2_.sort();
         return this.testPatterns;
      }
      
      private function returnTestPatterns() : Array
      {
         return ["[a4]mmysh[o0]p","[i1|l]nst[a4]ntd[e3][il1|][i1|l]v[e3]ry","[i1|l]nst[a4]p[o0]ts","[i1|l]p[o0]?tsc?[o0]?","[i1l].{0,15}p[o0]?ts.{0,15}c[o0]?","[i1l].{0,15}p[o0]?ts.{0,15}c[o0]?","[i1l].{0,15}p[o0]?ts.{0,15}c[o0]?","[il1|]nst[a4].{0,15}p[0o]ts","[o0]ryx.{0,5}in","[o0]ryxs[e3]t[o0][e3]u","[o0]ryxsho[o0]pru","buyfr[o0]mus","ch[e3][a4]p[o0]ryx","ch[e3][a4]pestp[o0]t[i1|l][0o]ns","ch[e3][a4]pst[a4]tp[o0]ts","d[o0]tc[o0]","d[o0]tn[e3]t","fr[e3][e3]mu[il1|][e3]","fr[e3][e3]r[o0]tmg","nst[a4].{0,15}p[0o]t[s5]","p[o0]t[i1|l][o0]ns.{0,15}r[o0]tmg","r[0o]?tmg.{0,15}[0o]ut","r[0o]?tmg.{0,15}c[a40o]","r[0o]?tmg.{0,15}gu[i1|l][i1|l]ds","r[0o]?tmg.{0,15}pr[0o]sh[0o]p","r[0o]?tmg.{0,15}s[a4][i1|l][e3]","r[0o]?tmg.{0,15}sh[0o]pn[i1|l]","r[0o]?tmg.{0,15}v[a4]u[i1|l]tc[0o]m","r[e3][a4][i1|l]mg[o0][o0]ds","r[e3][a4][i1|l]mg[o0]d","r[e3][a4][i1|l]mk[i1|l]ng","r[e3][a4][i1|l]mki[il1|]ngs","r[e3][a4][i1|l]mp[0o]ts","r[e3][a4][i1|l]mw[i1|l]nn[e3]r","r[o0]?tmg.{0,15}.{0,15}m[0o]dz","r[o0]?tmg.{0,15}[9p][o0].{0,15}c[o0]m"
         ,"r[o0]?tmg.{0,15}[o0]ut[l1i]et.{0,15}c[0o]m","r[o0]?tmg.{0,15}[s5][a4][l1i|][e3]","r[o0]?tmg.{0,15}p[0o].{0,15}c[0o]m","r[o0]?tmg.{0,15}w[s5]","wh[i1|l]t[e3].{0,15}b[a4]gd[0o]t","wh[i1|l]t[e3].{0,15}b[a4]gn[e3]t","wh[il1|]t[e3].{0,15}b[a4]gc[0o]m","atestingstring"];
      }
   }
}

