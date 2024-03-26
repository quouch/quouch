import"../client.js";import"../client/default.js";import"../util/normalizeHeaderName.js";import"../util/responsePromise.js";import"../util/mixin.js";import t from"../interceptor.js";var e={};var r;r=t;e=r({init:function(t){t.code=t.code||400;return t},response:function(t,e){return t.status&&t.status.code>=e.code?Promise.reject(t):t}});var i=e;export default i;

