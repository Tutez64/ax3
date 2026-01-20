/**
 * Test cases for ExprTyper.typeNew
 * Tests instantiation of various types handled specially in typeNew
 */
package {
	import flash.utils.Dictionary;

	public class TestExprTyperTypeNew {
		public function TestExprTyperTypeNew() {
			// Dictionary
			var d:Dictionary = new Dictionary();
			var d2:Dictionary = new Dictionary(true);

			// Class (via decl ref)
			var c:Class = TestExprTyperTypeNew;
			var instance:* = new c();

			// Vector
			var v:Vector.<int> = new Vector.<int>();
			var v2:Vector.<int> = new Vector.<int>(10);
			var v3:Vector.<int> = new Vector.<int>(10, true);

			// Array
			var a:Array = new Array();
			var a2:Array = new Array(10);
			var a3:Array = new Array(1, 2, 3);

			// RegExp
			var r:RegExp = new RegExp("abc");
			var r2:RegExp = new RegExp("abc", "g");

			// XML
			var x:XML = new XML("<root/>");

			// Object
			var o:Object = new Object();

			// Basic types (handled by typeNew)
			var s:String = new String("test");
			var n:Number = new Number(123);
			var i:int = new int(123);
			var u:uint = new uint(123);
			var b:Boolean = new Boolean(true);

			// Plain class
			var t:TestExprTyperTypeNew = new TestExprTyperTypeNew();
		}
	}
}