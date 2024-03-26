import{_ as e,a as r}from"../../_/30b88ddc.js";import{_ as t,a as n}from"../../_/6d2134c8.js";import"@mapbox/parse-mapbox-token";import"xtend";import"eventemitter3";var s={};function parseSingleHeader(e){var r=e.indexOf(":");var t=e.substring(0,r).trim().toLowerCase();var n=e.substring(r+1).trim();return{name:t,value:n}}
/**
 * Parse raw headers into an object with lowercase properties.
 * Does not fully parse headings into more complete data structure,
 * as larger libraries might do. Also does not deal with duplicate
 * headers because Node doesn't seem to deal with those well, so
 * we shouldn't let the browser either, for consistency.
 *
 * @param {string} raw
 * @returns {Object}
 */function parseHeaders$1(e){var r={};if(!e)return r;e.trim().split(/[\r|\n]+/).forEach((function(e){var t=parseSingleHeader(e);r[t.name]=t.value}));return r}s=parseHeaders$1;var o=s;var a={};var i=e;var u=r;var d=t;var c=o;var p={};function browserAbort(e){var r=p[e.id];if(r){r.abort();delete p[e.id]}}function createResponse(e,r){return new i(e,{body:r.response,headers:c(r.getAllResponseHeaders()),statusCode:r.status})}function normalizeBrowserProgressEvent(e){var r=e.total;var t=e.loaded;var n=100*t/r;return{total:r,transferred:t,percent:n}}function sendRequestXhr(e,r){return new Promise((function(t,n){r.onprogress=function(r){e.emitter.emit(d.EVENT_PROGRESS_DOWNLOAD,normalizeBrowserProgressEvent(r))};var s=e.file;s&&(r.upload.onprogress=function(r){e.emitter.emit(d.EVENT_PROGRESS_UPLOAD,normalizeBrowserProgressEvent(r))});r.onerror=function(e){n(e)};r.onabort=function(){var r=new u({request:e,type:d.ERROR_REQUEST_ABORTED});n(r)};r.onload=function(){delete p[e.id];if(r.status<200||r.status>=400){var s=new u({request:e,body:r.response,statusCode:r.status});n(s)}else t(r)};var o=e.body;"string"===typeof o?r.send(o):o?r.send(JSON.stringify(o)):s?r.send(s):r.send();p[e.id]=r})).then((function(r){return createResponse(e,r)}))}function createRequestXhr(e,r){var t=e.url(r);var n=new window.XMLHttpRequest;n.open(e.method,t);Object.keys(e.headers).forEach((function(r){n.setRequestHeader(r,e.headers[r])}));return n}function browserSend(e){return Promise.resolve().then((function(){var r=createRequestXhr(e,e.client.accessToken);return sendRequestXhr(e,r)}))}a={browserAbort:browserAbort,sendRequestXhr:sendRequestXhr,browserSend:browserSend,createRequestXhr:createRequestXhr};var v=a;var l={};var f=v;var w=n;function BrowserClient(e){w.call(this,e)}BrowserClient.prototype=Object.create(w.prototype);BrowserClient.prototype.constructor=BrowserClient;BrowserClient.prototype.sendRequest=f.browserSend;BrowserClient.prototype.abortRequest=f.browserAbort;
/**
 * Create a client for the browser.
 *
 * @param {Object} options
 * @param {string} options.accessToken
 * @param {string} [options.origin]
 * @returns {MapiClient}
 */function createBrowserClient(e){return new BrowserClient(e)}l=createBrowserClient;var b=l;export{b as default};

