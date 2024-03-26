import t from"xtend";import e from"fuzzy";var i={};var List=function(t){this.component=t;this.items=[];this.active=0;this.wrapper=document.createElement("div");this.wrapper.className="suggestions-wrapper";this.element=document.createElement("ul");this.element.className="suggestions";this.wrapper.appendChild(this.element);this.selectingListItem=false;t.el.parentNode.insertBefore(this.wrapper,t.el.nextSibling);return this};List.prototype.show=function(){this.element.style.display="block"};List.prototype.hide=function(){this.element.style.display="none"};List.prototype.add=function(t){this.items.push(t)};List.prototype.clear=function(){this.items=[];this.active=0};List.prototype.isEmpty=function(){return!this.items.length};List.prototype.isVisible=function(){return"block"===this.element.style.display};List.prototype.draw=function(){this.element.innerHTML="";if(0!==this.items.length){for(var t=0;t<this.items.length;t++)this.drawItem(this.items[t],this.active===t);this.show()}else this.hide()};List.prototype.drawItem=function(t,e){var i=document.createElement("li"),s=document.createElement("a");e&&(i.className+=" active");s.innerHTML=t.string;i.appendChild(s);this.element.appendChild(i);i.addEventListener("mousedown",function(){this.selectingListItem=true}.bind(this));i.addEventListener("mouseup",function(){this.handleMouseUp.call(this,t)}.bind(this))};List.prototype.handleMouseUp=function(t){this.selectingListItem=false;this.component.value(t.original);this.clear();this.draw()};List.prototype.move=function(t){this.active=t;this.draw()};List.prototype.previous=function(){this.move(0===this.active?this.items.length-1:this.active-1)};List.prototype.next=function(){this.move(this.active===this.items.length-1?0:this.active+1)};List.prototype.drawError=function(t){var e=document.createElement("li");e.innerHTML=t;this.element.appendChild(e);this.show()};i=List;var s=i;var n={};var r=t;var h=e;var o=s;var Suggestions=function(t,e,i){i=i||{};this.options=r({minLength:2,limit:5,filter:true,hideOnBlur:true},i);this.el=t;this.data=e||[];this.list=new o(this);this.query="";this.selected=null;this.list.draw();this.el.addEventListener("keyup",function(t){this.handleKeyUp(t.keyCode)}.bind(this),false);this.el.addEventListener("keydown",function(t){this.handleKeyDown(t)}.bind(this));this.el.addEventListener("focus",function(){this.handleFocus()}.bind(this));this.el.addEventListener("blur",function(){this.handleBlur()}.bind(this));this.el.addEventListener("paste",function(t){this.handlePaste(t)}.bind(this));this.render=this.options.render?this.options.render.bind(this):this.render.bind(this);this.getItemValue=this.options.getItemValue?this.options.getItemValue.bind(this):this.getItemValue.bind(this);return this};Suggestions.prototype.handleKeyUp=function(t){40!==t&&38!==t&&27!==t&&13!==t&&9!==t&&this.handleInputChange(this.el.value)};Suggestions.prototype.handleKeyDown=function(t){switch(t.keyCode){case 13:case 9:if(!this.list.isEmpty()){this.list.isVisible()&&t.preventDefault();this.value(this.list.items[this.list.active].original);this.list.hide()}break;case 27:this.list.isEmpty()||this.list.hide();break;case 38:this.list.previous();break;case 40:this.list.next();break}};Suggestions.prototype.handleBlur=function(){!this.list.selectingListItem&&this.options.hideOnBlur&&this.list.hide()};Suggestions.prototype.handlePaste=function(t){if(t.clipboardData)this.handleInputChange(t.clipboardData.getData("Text"));else{var e=this;setTimeout((function(){e.handleInputChange(t.target.value)}),100)}};Suggestions.prototype.handleInputChange=function(t){this.query=this.normalize(t);this.list.clear();this.query.length<this.options.minLength?this.list.draw():this.getCandidates(function(t){for(var e=0;e<t.length;e++){this.list.add(t[e]);if(e===this.options.limit-1)break}this.list.draw()}.bind(this))};Suggestions.prototype.handleFocus=function(){this.list.isEmpty()||this.list.show();this.list.selectingListItem=false};
/**
 * Update data previously passed
 *
 * @param {Array} revisedData
 */Suggestions.prototype.update=function(t){this.data=t;this.handleKeyUp()};Suggestions.prototype.clear=function(){this.data=[];this.list.clear()};
/**
 * Normalize the results list and input value for matching
 *
 * @param {String} value
 * @return {String}
 */Suggestions.prototype.normalize=function(t){t=t.toLowerCase();return t};
/**
 * Evaluates whether an array item qualifies as a match with the current query
 *
 * @param {String} candidate a possible item from the array passed
 * @param {String} query the current query
 * @return {Boolean}
 */Suggestions.prototype.match=function(t,e){return t.indexOf(e)>-1};Suggestions.prototype.value=function(t){this.selected=t;this.el.value=this.getItemValue(t);if(document.createEvent){var e=document.createEvent("HTMLEvents");e.initEvent("change",true,false);this.el.dispatchEvent(e)}else this.el.fireEvent("onchange")};Suggestions.prototype.getCandidates=function(t){var e={pre:"<strong>",post:"</strong>",extract:function(t){return this.getItemValue(t)}.bind(this)};var i;if(this.options.filter){i=h.filter(this.query,this.data,e);i=i.map(function(t){return{original:t.original,string:this.render(t.original,t.string)}}.bind(this))}else i=this.data.map(function(t){var e=this.render(t);return{original:t,string:e}}.bind(this));t(i)};
/**
 * For a given item in the data array, return what should be used as the candidate string
 *
 * @param {Object|String} item an item from the data array
 * @return {String} item
 */Suggestions.prototype.getItemValue=function(t){return t};
/**
 * For a given item in the data array, return a string of html that should be rendered in the dropdown
 * @param {Object|String} item an item from the data array
 * @param {String} sourceFormatting a string that has pre-formatted html that should be passed directly through the render function 
 * @return {String} html
 */Suggestions.prototype.render=function(t,e){if(e)return e;var i=t.original?this.getItemValue(t.original):this.getItemValue(t);var s=this.normalize(i);var n=s.lastIndexOf(this.query);while(n>-1){var r=n+this.query.length;i=i.slice(0,n)+"<strong>"+i.slice(n,r)+"</strong>"+i.slice(r);n=s.slice(0,n).lastIndexOf(this.query)}return i};
/**
 * Render an custom error message in the suggestions list
 * @param {String} msg An html string to render as an error message
 */Suggestions.prototype.renderError=function(t){this.list.drawError(t)};n=Suggestions;var a=n;var l={};
/**
 * A typeahead component for inputs
 * @class Suggestions
 *
 * @param {HTMLInputElement} el A valid HTML input element
 * @param {Array} data An array of data used for results
 * @param {Object} options
 * @param {Number} [options.limit=5] Max number of results to display in the auto suggest list.
 * @param {Number} [options.minLength=2] Number of characters typed into an input to trigger suggestions.
 * @param {Boolean} [options.hideOnBlur=true] If `true`, hides the suggestions when focus is lost.
 * @return {Suggestions} `this`
 * @example
 * // in the browser
 * var input = document.querySelector('input');
 * var data = [
 *   'Roy Eldridge',
 *   'Roy Hargrove',
 *   'Rex Stewart'
 * ];
 *
 * new Suggestions(input, data);
 *
 * // with options
 * var input = document.querySelector('input');
 * var data = [{
 *   name: 'Roy Eldridge',
 *   year: 1911
 * }, {
 *   name: 'Roy Hargrove',
 *   year: 1969
 * }, {
 *   name: 'Rex Stewart',
 *   year: 1907
 * }];
 *
 * var typeahead = new Suggestions(input, data, {
 *   filter: false, // Disable filtering
 *   minLength: 3, // Number of characters typed into an input to trigger suggestions.
 *   limit: 3, //  Max number of results to display.
 *   hideOnBlur: false // Don't hide results when input loses focus
 * });
 *
 * // As we're passing an object of an arrays as data, override
 * // `getItemValue` by specifying the specific property to search on.
 * typeahead.getItemValue = function(item) { return item.name };
 *
 * input.addEventListener('change', function() {
 *   console.log(typeahead.selected); // Current selected item.
 * });
 *
 * // With browserify
 * var Suggestions = require('suggestions');
 *
 * new Suggestions(input, data);
 */var d=a;l=d;"undefined"!==typeof window&&(window.Suggestions=d);var p=l;export default p;

