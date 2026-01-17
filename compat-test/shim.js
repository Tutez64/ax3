// Shim to mock browser environment for OpenFL/Lime running in Node.js
global.window = global;

// Mock Canvas and Context2D
var mockContext2D = {
    fillRect: function() {},
    clearRect: function() {},
    getImageData: function() { return { data: [] }; },
    putImageData: function() {},
    createImageData: function() { return { data: [] }; },
    drawImage: function() {},
    save: function() {},
    restore: function() {},
    translate: function() {},
    rotate: function() {},
    scale: function() {},
    transform: function() {},
    setTransform: function() {},
    beginPath: function() {},
    moveTo: function() {},
    lineTo: function() {},
    clip: function() {},
    fill: function() {},
    stroke: function() {},
    measureText: function() { return { width: 0 }; }
};

var mockCanvas = {
    style: {},
    getContext: function() { return mockContext2D; },
    width: 0,
    height: 0
};

global.document = {
    createElement: function(tag) {
        if (tag === 'canvas') {
            return mockCanvas;
        }
        return { style: {} };
    },
    addEventListener: function() {},
    removeEventListener: function() {},
    documentElement: {},
    body: {
        appendChild: function() {}
    }
};

global.location = { href: 'http://localhost' };
global.navigator = { userAgent: 'Node.js' };
global.XMLHttpRequest = function() {};
global.requestAnimationFrame = function(callback) { setTimeout(callback, 16); };
global.cancelAnimationFrame = function(id) { clearTimeout(id); };
global.Image = function() {};
