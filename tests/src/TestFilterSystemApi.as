/**
 * Test case for System API rewrites.
 * Covers:
 * - flash.system.System.pauseForGCIfCollectionImminent() rewritten to ASCompat helper.
 * - Optional threshold argument propagation.
 */
package {
    import flash.system.System;

    public class TestFilterSystemApi {
        public function TestFilterSystemApi() {
            System.pauseForGCIfCollectionImminent();
            System.pauseForGCIfCollectionImminent(0.5);
        }
    }
}
