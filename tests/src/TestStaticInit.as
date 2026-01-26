/**
 * Test case: class-level expressions should be parsed as static initializers.
 * Static init should allow Dictionary and Array literal assignments.
 */
package {
    import flash.utils.Dictionary;

    public class TestStaticInit {
        private static var SCREENSHOTS:Dictionary = new Dictionary();

        SCREENSHOTS["RANGER"] = ["image_ranger01","image_ranger02"];
        SCREENSHOTS["SORCERER"] = ["image_sorcerer01","image_sorcerer02"];

        private static var SOMETHING:Dictionary = new Dictionary();
        private static var SOMETHING_ELSE:Dictionary = new Dictionary();

        SOMETHING["idk"] = ["doesn't matter"];
        SOMETHING_ELSE["idk"] = ["doesn't matter"];
    }
}
