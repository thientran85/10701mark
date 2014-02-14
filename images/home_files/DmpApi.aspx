if (typeof (Dmp) == 'undefined') Dmp = new Object();
var _TOOLKIT_LOCATION='http://parcelstream.com/api/lib\\4.0\\Legacy/';Dmp.HostName='http://parcelstream.com/';
// Create namespace
if (typeof (Dmp) == 'undefined') Dmp = new Object();
if (typeof (Dmp.Core) == 'undefined') Dmp.Core = new Object();
if (typeof (Dmp.Core.QueryModel) == 'undefined') Dmp.Core.QueryModel = new Object();
if (typeof (Dmp.Core.WktTools) == 'undefined') Dmp.Core.WktTools = new Object();
if (typeof (Dmp.Core.Collections) == "undefined") Dmp.Core.Collections = new Object();
if (typeof (Dmp.Core.Layers) == 'undefined') Dmp.Core.Layers = new Object();
if (typeof (Dmp.Core.Layers.MapLayers) == 'undefined') Dmp.Core.Layers.MapLayers = new Object();
if (typeof (Dmp.Layers) == 'undefined') Dmp.Layers = new Object();
if (typeof (Dmp.Layer) == 'undefined') Dmp.Layer = new Object();
if (typeof (Dmp.Drawing) == 'undefined') Dmp.Drawing = new Object();
if (typeof (Dmp.Env) == 'undefined') Dmp.Env = new Object();
if (typeof (Dmp.Conn) == "undefined") Dmp.Conn = new Object();
if (typeof (Dmp.Util) == 'undefined') Dmp.Util = new Object();
if (typeof (Dmp.Abstraction) == 'undefined') Dmp.Abstraction = new Object();
if (typeof (Dmp.Legacy) == 'undefined') Dmp.Legacy = new Object();
if (typeof (Dmp.Identify) == 'undefined') Dmp.Identify = new Object();
if (typeof (Dmp.Map) == 'undefined') Dmp.Map = new Object();
if (typeof (Dmp.Cookbook) == 'undefined') Dmp.Cookbook = new Object();





/**
 * Generates a unique string that are generally used for creating IDs for temporary objects.
 * @returns the unique string
 * @syntax: public static String Dmp.Util.getGuid() 
 * @returns a unique string
 * @type {String}
 */
Dmp.Util.getGuid = function() {
    if (!Dmp.Util._guidCount) Dmp.Util._guidCount = 1;
    var tday = new Date();
    var rand = Math.floor(Math.random() * 2000000000)
    return tday.getTime() + "" + rand + "" + Dmp.Util._guidCount++;
};  //getGuid


/**
 * Takes a key-value pair Json object and uses the key to set the respective property on the targetObject.
 * functions and properties starting with "_" cannot be overwritten in this way.
 * @params {Object} targetObject.  Object to get its properties populated.  Required.
 * @params {Object} json.  Used to populate the targetObject.  The key must match the desired property to set.  Required.
 * @private 
 */
Dmp.Util._populateFromJson = function(targetObject, json) {
    for(var n in json) {
        if(n && n.length > 0 && n.charAt(0) == "_") continue;
        if(typeof(targetObject[n]) == "function") continue;
	    targetObject[n] = json[n];
    }
}

/**
 * @params {Bing Maps object} map.  Required.
 * @returns  the current zoom level of the given Bing Map.
 * @type {Number}
 */
Dmp.Util.getZoomLevel = function(map) {
    if(!map || !map.getZoom) return 1;
    return map.getZoom();
}

/**
 * @params {Bing Maps object} map.  Required.
 * @returns  an Object with xMin, yMax, yMin, yMax properties representing the current map's view
 * @type {object{
 */

Dmp.Util.getMapView = function(map) {

    var view = map.getBounds();
    var mapView = {
        xMin : view.getWest(),
        xMax : view.getEast(),
        yMin : view.getSouth(),
        yMax : view.getNorth()
    };
    return mapView;
}
/**
 * @author Jon Davis <jon@jondavis.net>
 * @version 1.3.1
 */
var using = window.using = function( scriptName, callback, context ) {
    function durl(sc) {
        var su = sc;
        if (sc && sc.substring(0, 4) == "url(") {
            su = sc.substring(4, sc.length - 1);
        }
        var r = using.registered[su];
        return (!r && (!using.__durls || !using.__durls[su]) &&
                sc && sc.length > 4 && sc.substring(0, 4) == "url(");
    }
    var a=-1;
    var scriptNames = new Array();
    if (typeof(scriptName) != "string" && scriptName.length) {
        var _scriptNames = scriptName;
        for (var s=0;s<_scriptNames.length; s++) {
            if (using.registered[_scriptNames[s]] || durl(_scriptNames[s])) {
                scriptNames.push(_scriptNames[s]);
            }
        }
        scriptName = scriptNames[0];
        a=1;
    } else {
        while (typeof(arguments[++a]) == "string") {
            if (using.registered[scriptName] || durl(scriptName)) {
                scriptNames.push(arguments[a]);
            }
        }
    }
        
    callback = arguments[a];
    context = arguments[++a];
    
    if (scriptNames.length > 1) {
        var cb = callback;
        callback = function() {
            using(scriptNames, cb, context);
        }
    }
    
    var reg = using.registered[scriptName];
    if (!using.__durls) using.__durls = {};
    if (durl(scriptName) && scriptName.substring(0, 4) == "url(") {
        scriptName = scriptName.substring(4, scriptName.length - 1);
        if (!using.__durls[scriptName]) {
            scriptNames[0] = scriptName;
            using.register(scriptName, true,  scriptName);
            reg = using.registered[scriptName];
            var callbackQueue = using.prototype.getCallbackQueue(scriptName);
            var cbitem = new using.prototype.CallbackItem(function() {
                using.__durls[scriptName] = true;
            });
            callbackQueue.push(cbitem);
            callbackQueue.push(new using.prototype.CallbackItem(callback, context));
            callback = undefined;
            context = undefined;
        }
    }
    if (reg) {
    
        // load dependencies first
        for (var r=reg.requirements.length-1; r>=0; r--) {
            if (using.registered[reg.requirements[r].name]) {
                using(reg.requirements[r].name, function() {
                    using(scriptName, callback, context); 
                }, context);
                return;
            }
        }
        
        // load each script URL
        for (var u=0; u<reg.urls.length; u++) {
            if (u == reg.urls.length - 1) {
                if (callback) {
                    using.load(reg.name, reg.urls[u], reg.remote, reg.asyncWait,
                        new using.prototype.CallbackItem(callback, context));
                } else {
                    using.load(reg.name, reg.urls[u], reg.remote, reg.asyncWait);
                }
            } else {
                using.load(reg.name, reg.urls[u], reg.remote, reg.asyncWait);
            }
        }
        
    } else {
        var cb = callback;
        if (cb) {
            cb.call(context);
        }
    }
}

using.prototype = {	

    CallbackItem : function(_callback, _context) {
        this.callback = _callback;
        this.context = _context;
        this.invoke = function() {
            if (this.context) this.callback.call(this.context);
            else this.callback();
        };
    },

	Registration : function(_name, _version, _remote, _asyncWait, _urls) {
	    this.name = _name;
	    var a=0;
	    var arg = arguments[++a];
	    var v=true;
	    if (typeof(arg) == "string") {
	        for (var c=0; c<arg.length; c++) {
	            if ("1234567890.".indexOf(arg.substring(c)) == -1) {
	                v = false;
	                break;
	            }
	        }
	        if (v) {
	            this.version = arg; // not currently used
	            arg = arguments[++a];
	        } else {
	            this.version = "1.0.0"; // not currently used
	        }
	    }
	    if (arg && typeof(arg) == "boolean") {
	        this.remote = arg;
	        arg = arguments[++a];
	    } else {
	        this.remote = false;
	    }
	    if (arg && typeof(arg) == "number") {
	        this.asyncWait = _asyncWait;
        } else {
            this.asyncWait = 0;
        }
	    this.urls = new Array();
	    if (arg && arg.length && typeof(arg) != "string") {
	        this.urls = arg;
	    } else {
	        for (a=a; a<arguments.length; a++) {
	            if (arguments[a] && typeof(arguments[a]) == "string") {
	                this.urls.push(arguments[a]);
	            }
	        }
	    }
	    this.requirements = new Array();
	    this.requires = function(resourceName, minimumVersion) {
	        if (!minimumVersion) minimumVersion = "1.0.0"; // not currently used
	        this.requirements.push({
	            name: resourceName,
	            minVersion: minimumVersion // not currently used
	            });
	        return this;
	    }
	    this.register = function(name, version, remote, asyncWait, urls) {
	        return using.register(name, version, remote, asyncWait, urls);
	    }
	    return this;
	},

    register : function(name, version, remote, asyncWait, urls) {
        var reg;
        if (typeof(name) == "object") {
            reg = name;
            reg = new using.prototype.Registration(reg.name, reg.version, reg.remote, reg.asyncWait, urls);
        } else {
            reg = new using.prototype.Registration(name, version, remote, asyncWait, urls);
        }
        if (!using.registered) using.registered = { };
        if (using.registered[name] && window.console) {
            window.console.log("Warning: Resource named \"" + name + "\" was already registered with using.register(); overwritten.");
        }
        using.registered[name] = reg;
        return reg;
    },
	
	wait: 0,
	
	defaultAsyncWait: 250,
	
	getCallbackQueue: function(scriptUrl) {
		if (!using.__callbackQueue) {
			using.__callbackQueue = {};
		}
 		var callbackQueue = using.__callbackQueue[scriptUrl];
 		if (!callbackQueue) {
 		    callbackQueue = using.__callbackQueue[scriptUrl] = new Array();
 		}
 		return callbackQueue;
	},
	
	load: function(scriptName, scriptUrl, remote, asyncWait, cb) {
		if (asyncWait == undefined) asyncWait = using.wait;
		if (remote && asyncWait == 0) asyncWait = using.defaultAsyncWait;
		
		if (!using.loadedScripts) using.loadedScripts = new Array();

 		var callbackQueue = using.prototype.getCallbackQueue(scriptUrl);
 		callbackQueue.push(new using.prototype.CallbackItem( function() {
 		    using.loadedScripts.push(using.registered[scriptName]);
 		    using.registered[scriptName] = undefined;
 		}, null));
 		if (cb) {
 		    callbackQueue.push(cb);
 		    if (callbackQueue.length > 2) return;
 		}
 		if (remote) {
 		    using.srcScript(scriptUrl, asyncWait, callbackQueue);
 		} else {
			var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject) {
				xhr = new ActiveXObject("Microsoft.XMLHTTP"); 
			}
			xhr.onreadystatechange = function(){
				if (xhr.readyState == 4 && xhr.status == 200) {
					using.injectScript(xhr.responseText, scriptName);
					if (callbackQueue) {
					    for (var q=0; q<callbackQueue.length; q++) {
					        callbackQueue[q].invoke();
					    }
					}
					using.__callbackQueue[scriptUrl] = undefined;
				}
			};
			if (asyncWait > 0 || callbackQueue.length > 1) {
			    xhr.open("GET", scriptUrl, true);
			} else {
			    xhr.open("GET", scriptUrl, false);
			}
			xhr.send(null);
 		}
	}, 
	
	genScriptNode : function() {
		var scriptNode = document.createElement("script");
		scriptNode.setAttribute("type", "text/javascript");
		scriptNode.setAttribute("language", "JavaScript");
		return scriptNode;	
	},
	srcScript : function(scriptUrl, asyncWait, callbackQueue) {
		var scriptNode = using.prototype.genScriptNode();
		scriptNode.setAttribute("src", scriptUrl);
		if (callbackQueue) {
		    var execQueue = function() {
				using.__callbackQueue[scriptUrl] = undefined;
			    for (var q=0; q<callbackQueue.length; q++) {
			        callbackQueue[q].invoke();
			    }
			    callbackQueue = new Array(); // reset
		    }
			scriptNode.onload = scriptNode.onreadystatechange = function() {
				if ((!scriptNode.readyState) || scriptNode.readyState == "loaded" || scriptNode.readyState == "complete" ||
					scriptNode.readyState == 4 && scriptNode.status == 200) {
					if (asyncWait > 0) {
						setTimeout(execQueue, asyncWait);
					}
					else {
						execQueue();
					}
				}
			};
		}
		var headNode = document.getElementsByTagName("head")[0];
		headNode.appendChild(scriptNode);
	},
	injectScript : function(scriptText, scriptName) {
		var scriptNode = using.prototype.genScriptNode();
		try {
		    scriptNode.setAttribute("name", scriptName);
		} catch (err) { }
		scriptNode.text = scriptText;
		var headNode = document.getElementsByTagName("head")[0];
		headNode.appendChild(scriptNode);
	}
};
using.register = using.prototype.register;
using.load = using.prototype.load;
using.wait = using.prototype.wait;
using.defaultAsyncWait = using.prototype.defaultAsyncWait;
using.srcScript = using.prototype.srcScript;
using.injectScript = using.prototype.injectScript;
//Make sure registered always exists. -MW 5/1/08
using.registered = { };
/**
 * @class
 * Interface for Styles classes.  
 * Current supported types: SldPath, SldBody
 */
Dmp.Drawing.IStyle= function() {

    var _styleValue = "";
    var _attributeLink = "";
    
    /**
     * Sets the style, whether the value should be a Path or a Body depends on the inherited class
     */    
    this.setStyleValue = function( val ) {
        _styleValue = val;
    }    
    this.getStyleValue = function() {
        return _styleValue;
    }
    
    this.setAttributeLink = function( val ) {
        _attributeLink = val;
    }    
    this.getAttributeLink = function() {
        return _attributeLink;
    }
    
}
/**
 * @class
 * SldStyle contains a path (as a string) to the location of the SLD definition.
 * @requires {IStyle}
 * @see Dmp.Drawing.IStyle
 * @params {String} sldBody.  Path to the SLD definition.  Can be set after initialization.  Optional.
 * @params {String} attLink.  Attribute link for this SLD.  Can be set after initialization.  Optional.
 */
Dmp.Drawing.SldStyle = function(sldPath, attLink) {

    var _self = this;    
    var _sldPath = sldPath;
           
    this.base = Dmp.Drawing.IStyle;
    this.base();
    
    this.setStyleValue(sldPath);
    this.setAttributeLink(attLink);
        
    this.getType = function(){ return "path"; }
    
    /**
     * Accessor to this Style object's style
     * @returns the value of the style.  In this case, a path to the SLD definition.
     * @type {String}
     * @deprecated.  use getStyleValue()
     */    
    this.styleValue = function() {
        return _sldPath;
    }
    
    /**
     * @deprecated
     */
    this.getSldPath = function() {
        return _sldPath;
    }   
    
    /**
     * Serializes this style object into an xml string, mainly used for creaing map composition files.
     * @returns string of the form: <Style Class=[CLASS] AttributeLink=[ATTRIBUTELINK]>[SLDPATH]</Style>
     * @type {String}
     */
    this.toXml = function() {
        var xml = "<Style Class='Dmp.Core.Drawing.SldStyle'";
        
        if( _self.getAttributeLink() ) {
            xml += " AttributeLink='" + _self.getAttributeLink() + "'";
        }
        xml += ">" + _sldPath + "</Style>";
        return xml;
    }
}
/**
 * @class
 * SldBody contains a string representation of the SLD definition.
 * @requires {IStyle}
 * @see Dmp.Drawing.IStyle
 * @params {String} sldBody.  String representation of the SLD definition.  Can be set after initialization.  Optional.
 * @params {String} attLink.  Attribute link for this SLD.  Can be set after initialization.  Optional.
 */
Dmp.Drawing.SldBodyStyle = function(sldBody, attLink) {

    var _self = this;        
    var _sldBody = sldBody;    
    
    this.base = Dmp.Drawing.IStyle;
    this.base();    
    this.setStyleValue(sldBody);
    this.setAttributeLink(attLink);              
    this.getType = function(){ return "body" };
    
    
    /**
     * Accessor to this Style object's style
     * @returns the value of the style.  In this case, a string representation of the SLD definition.
     * @type {String}
     * @deprecated.  use getStyleValue()
     */
    this.styleValue = function() {
        return _sldBody;
    }
    
    
    /**
     * Serializes this style object into an xml string, mainly used for creaing map composition files.
     * @returns string of the form: <Style Class=[CLASS] AttributeLink=[ATTRIBUTELINK]>[BODY]</Style>
     * @type {String}
     */
    this.toXml = function() {
        var xml = "<Style Class='Dmp.Core.Drawing.SldBodyStyle'";
        
        if( _self.getAttributeLink() ) {
            xml += " AttributeLink='" + _self.getAttributeLink() + "'";
        }
        xml += ">" + _sldBody + "</Style>";
        return xml;
    }
}
/**
 * CONFIDENTIAL AND PROPRIETARY
 * This document is confidential and contains proprietary information.
 * Neither this document nor any of the information contained herein
 * may be reproduced or disclosed to any person under any circumstances
 * without the express written consent of Digital Map Products.
 *
 * Copyright:    Copyright (c) 2010
 * Company:      Digital Map Products
 * @author       Gregory
 * @version      1.0
 *
 */
 
 
/**
 * @class
 * Links an IMapLayer and a Resource.
 * Contains descriptive, bounding, preferences, and other information.
 * resourceName, connectionId, connectionUrl, and ID should not change after construction.
 * NOTE: For the "style" property to function correctly, it must be set by using RES.attr("style", INPUT), where input can be
    a string to the SLD's path, a string defining the SLD's body, a Dmp.Drawing.SldStyle class or a Dmp.Drawing.SldBodyStyle class
 * @param {Object} nameOrXml.  Could be XML dom or a resourceName (string).  If it is an Xml Dom, the Xml must have a resourceName defined.  Required.
 * @param {String} connectionId.  ID of the Connection object that this ResourceReference belongs.  Required if no Xml Dom is provided. 
 * @param {Object} params.  Json style object to parameterize this ResourceReference.  Optional
 */
Dmp.Layer.ResourceReference = function(nameOrXml, connectionId, params) {

    if(!nameOrXml) { return; }
    if(typeof(nameOrXml) == "string" && !connectionId) { return; }

	var _self = this;
	var _sourceUrl = null;
		
	if(typeof(nameOrXml) == "string") { this.resourceName = nameOrXml;};

    this.connectionId = connectionId;
	this.dataResourceName = null;
	this.title = null;
	this.abstract = null; 
	this.attribution = null;
	this.visibilityPreference = true;
	this.visibilityTrueCondition = null;
	this.visibilityFalseCondition = null;
	this.zoomRange = {min:1, max:21};
	this.zoomScaleRange = new Object();
	this.bounds = null;
	this.identifiablePreference = true;
	this.style = null; 
	var _style = null;
	this.conditionStyles = new Array();
	this.time = null;
	this.filter = null;
	this.attributeLinks = null;
	this.keyFields = null;
	this.hotspotId = null;
	this.hotspotPreference = false;
	this._observers = new Object();
	this._ldr = null;
	
	if(params) { this.connectionUrl = params.connectionUrl; }
		
    
    

	/** 
	 * Determines if this ResourceReference is visible based on its 'visibilityPreference' property, the zoomRange, and bounds.
	 * @param {Object} map.  Handle to the map control object.  Used to get bounds/scale information.  Required.
	 * @returns True if the MapView is in the layer's zoom range, bounds, and visibilityPreference == true
	 * @type {Boolean}
	 */
	this.isVisible = function(map) {        

		if(_self.visibilityPreference == false) {
			return false;
		}
		
		var zoomLevel = Dmp.Util.getZoomLevel(map);
		if( _self.zoomRange.max < zoomLevel || _self.zoomRange.min > zoomLevel ) {
			return false;
		}
		
		
		if( typeof(_self.isInBounds) != "undefined" && !_self.isInBounds(map) ) {
		    return false;
		}
		
						
		return true;
	} //isVisible
	
	/**
	 * Accessor/Mutator method for all properties on this object.
	 * Sets 'property' to 'val' if both are provided, returns 'property' otherwise
	 * @param {String} property.  A string matching the name of a property on this object.  Required.
	 * @param {Object} val.  An object matching the type of this[property].  Optional.
	 * @returns  The value of the given property if 'val' is not provided.  Returns null otherwise.
	 * @type {Object}
	 */
	this.attr = function(property, val){
	    if(typeof(val) != "undefined") {
	        _self[property] = val;
	        if(property == "hotspotId" && _self.displayCache) _self.displayCache.hotspotId = val;
	        
	        for (var n in _self._observers['onPropertyChange']) {
			    _self._observers['onPropertyChange'][n]({property:property, val:val});
			}	       
	    } else {
	        if( property == "style") { return _style; }
			return _self[property];
		}
	}
	
	
    /**
	 * Attach a listener to 'event' and invoke 'funct' upon trigger.
	 * The callback function will be parameterized with ([EVENT], {[VALUES (if applicable)]}).
	 * Current supported events: "onPropertyChange".
	 * @param {String} event. The event to observe.  Required.
	 * @param {Function} funct.  The function to be invoke when the given event is triggered.  Required.
	 */
	this.addCallback = function(event, funct) {
	    
	    if(!event || typeof(event) != "string") {
	        return null;
	    } else if (!funct || typeof(funct) != "function") {
	        return null;
	    }
	    
	    if(typeof(_self._observers[event]) == "undefined") {
	        _self._observers[event] = new Array();
	    }
	    return (_self._observers[event].push(funct) - 1);
	}	

	/**
	 * Removes callback(s) from this Wms Layer object.
	 * If only an 'eventType' is provided, all observers of 'eventType' will be removed.
	 * If an 'id' is provided, only that observer of 'eventType' will be removed.
	 * The 'id' is just the index of the callback function (returned by .addCallback
	 * @params {String} eventType.  The name of the event.  Required.
	 * @params {Int} id.  The id (index) of the callback to remove.  Optional.
	 */
	this.removeCallback = function(eventType, id) {	    
	    if(!_self._observers[eventType]) return;
	    if( id ) id = parseInt(id);
	    if(!id) {
	        for(var i in _self._observers[eventType]) {
	            delete _self._observers[eventType][i];
	        }	    
	    } else {	    	            	    
	        if( id < 0 || id >= _self._observers[eventType].length) return;
	        delete _self._observers[eventType][id];
	    }	
	}
	
	//add a listener to "style" property change
	//create a Dmp.Drawing.IStyle object when it changes
	//improves consistency of the 'style' property (it's always an object)
	this.addCallback("onPropertyChange", function(e) {
	    
	    if( e && e.property == "style" && typeof(e.val) == "string") {
	        if( e.val.indexOf("<") == 0 ) {
	            _style = new Dmp.Drawing.SldBodyStyle( e.val );
	        } else {	            
	            _style = new Dmp.Drawing.SldStyle( e.val );
	            
	        }
	    } else if ( e && e.property == "style" && typeof(e.val) != "undefined") {
	        _style = e.val;
	    }
	});
	
	if(typeof(_self._load) == "function") {
        _self._load(nameOrXml, connectionId, _self.connectionUrl);
    }
        
	if(params) {
	    Dmp.Util._populateFromJson(_self, params);
	    if(params.style) {
	        _self.attr("style", params.style);
	    }	    	    
	}
	this.connectionObj = Dmp.Env.Connections.getConnectionObject(_self.connectionId, _self.connectionUrl);
        

} //Dmp.Layer.ResourceReference

/**
 * CONFIDENTIAL AND PROPRIETARY
 * This document is confidential and contains proprietary information.
 * Neither this document nor any of the information contained herein
 * may be reproduced or disclosed to any person under any circumstances
 * without the express written consent of Digital Map Products.
 *
 * Copyright:    Copyright (c) 2010
 * Company:      Digital Map Products
 * @author       Gregory
 * @version      1.0
 *
 */
 



if ( typeof(Microsoft) != "undefined" && Microsoft && typeof(Microsoft.Maps) != "undefined") {

    /**
     * Container of Dmp IMapLayer objects that is stored as a property on the Bing Map object.  
     * @see Dmp.Layer.IMapLayer
     * @addon
     */
    Microsoft.Maps.Map.prototype.dmpLayers = new Array();	

	/**
	 * Adds a Dmp Layer object to the Bing Map object.
	 * Current supported types: Wms, Tile
	 * @addon
	 * @see Dmp.Layer.MapLayer
	 * @param {Object} layer.  Add an IMapLayer object (Wms, Tile, etc) to the map.  Required.
	 */ 
	Microsoft.Maps.Map.prototype.addEntity = function(entity){
		entity._addEntity(this);	
	}
	
	    
    /**
     * Returns the handle to the IMapLayer with the matching inputted ID.
     * @addon
     * @param {String} id.  The string that uniquely identifies this MapLayer.  Required.
     * @returns MapLayer object that has the matching ID.  Returns null otherwise.
     * @type {Object} MapLayer
     */
	Microsoft.Maps.Map.prototype.getDmpLayerById = function(id) {
        var arr = this.dmpLayers;        
        for(var i in arr) {            
            if( arr[i].id == id ) {
                return arr[i];
            }
        }
        return null;
	}
	
		
	/**
	 * Force all layers on the map to re-draw.
	 * Calls refresh on all layers associated with this map.  Refresh can be called on individual layers as well.
	 * @addon
	 */
	Microsoft.Maps.Map.prototype.refresh = function() {
	    var arr = this.dmpLayers;	    
	    for(var i in arr) {
            arr[i].refresh();
		}
	}
		
	/**
	 * Remove an IMapLayer from the Bing Map object.  
	 * This method uses splice (array length will change after each remove).
	 * @addon
	 * @param {Object or String} param.  An IMapLayer object or ID of the IMapLayer.  Required.
	 */
	Microsoft.Maps.Map.prototype.removeEntity = function(param){
	    var entity = param;
	    if(param && typeof(param) == "string") {
	        entity = this.getDmpLayerById(param);
	    }
	    if(!entity || typeof(entity._removeEntity) == "undefined") {
	        return;
	    }
		entity._removeEntity(this);
	}
	
	
}


/**
 * @class
 * Base class for Map Layers, which has the responsibility of displaying itself on the map.
 * Current supported types: Wms, Tile.
 * IMapLayers must be added to the map control via 'addLayer(IMapLayer)' to property function.
 */
Dmp.Layer.IMapLayer = function() {

	var _self = this;
	this._resourceReferences = new Array();	
	this._map = null;
	this.visibility = true;
	this.draw = function() {}
	
	/**
	 * @returns the layer resources associated with this layer
	 * @type {Array}
	*/
	this.getResourceReferences = function() {
		return _self._resourceReferences;
	}
}

/**
 * Takes a json object as input and determines which properties are valid GetMap parameters
 * Current supported parameters: "Color", "ViewInTime", "ActiveVersionId", "ShowField", "ShowValues", "HideField",
        "HideValues", "Output", "Transformer", "AntiAlias", "IgnoreHoles"
 * @params params.  Associative array of properties.  Extra/mispelled properties will be ignored.  Required.
 * @returns Associative array of valid GetMap properties and their values
 * @type {Object}
 * @private
 */
Dmp.Layer._checkRenderOptions = function(params){

    var validParameters = ["Color", "ViewInTime", "ActiveVersionId", "ShowField", "ShowValues", "HideField",
        "HideValues", "Output", "Transformer", "AntiAlias", "IgnoreHoles"];
    //NOT: query, hotspotfield, sld/body, attributelink
    var validOptions = new Object();
    for(var n in params) {                
        for(var i =0; i < validParameters.length; i++) {
            if(n.toLowerCase() == validParameters[i].toLowerCase()) {
                validOptions[n] = params[n];
                //break;
            }
        }
    
    }
    return validOptions;

} //_checkRenderOptions
/**
 * CONFIDENTIAL AND PROPRIETARY
 * This document is confidential and contains proprietary information.
 * Neither this document nor any of the information contained herein
 * may be reproduced or disclosed to any person under any circumstances
 * without the express written consent of Digital Map Products.
 *
 * Copyright:    Copyright (c) 2010
 * Company:      Digital Map Products
 * @author       Gregory
 * @version      1.0
 *
 */


/**
 * @class
 * Used to display Wms resources on the map and each WmsLayer can contain multiple Wms Resources.
 * Resources are added via Dmp.Layer.ResourceReference which are added using the '.addChild' method
 * @see this.addChild
 * @extends {Dmp.Layer.IMapLayer} 
 * @param {String} tagOrXml.  A string to uniquely identify this MapLayer or an Xml string definition of this layer.  Recommended.
 * @param {String} connectionId.  ID of the Connection object that this MapLayer belongs.  Required if a tag is provided.
 * @param {Object} params.  An associative array of layer properties and render options.  Optional.
 *  To add render options, simply add the options to the json object as a normal parameter.
 *  The render options will be appended to the GetMap requests (only valid options will be appended).
 *  The render options that have values dependent on the number of ResourceReferences in the layer are NOT supported.  To use these,
    add them at the ResourceReference level.  
 */
Dmp.Layer.WmsLayer = function(tagOrXml, connectionId, params) {

    if(!tagOrXml) {        
        tagOrXml = "WmsLayer" + Dmp.Util.getGuid();
    } else if( typeof(tagOrXml) != "object" && (!connectionId || (typeof(connectionId) != "string" && typeof(connectionId) != "number")) ) {
        //throw new Error("connectionId must be a non-empty string if no xmlDom is provided");
        return;
    }    
    
	this.base = Dmp.Layer.IMapLayer;
	this.base();	
	
	var _self = this;	
	this._pushpin = null;  //handle to the currently used pushpin
		
	this.layerDiv = null; //document element that will fetch the GetMap requests (pushpin's DOM)
	this.getClassName = function() { return "WmsLayer"; } //used mainly for map composition save
	this.connectionId = "" + connectionId;
	this.isSerialized = true; //capable of being saved into a map composition
	
	this._observers = new Object();  //container for user-defined custom event listeners
	var _listeners = new Array(); //container for Bing Maps event handlers
	var typeName = null;					
	/**
	 * Accessor/Mutator method for all properties on this object.  
	 * Sets 'property' if 'val' is provided, returns 'property' otherwise.
	 * Calls all observers listening to [onPropertyChange] (if any)
	    * callback is instantiated with {property, value}
	 * If a display property is changed, [LAYER].refresh should be invoked.
	 * @param {String} property.  A string matching the name of a property on this object.  Required.
	 * @param {Object} val.  An object matching the type of this[property].  Optional.
	 * @returns  The value of the given property if 'val' is not provided.  Returns null otherwise.
	 * @type {Object}
	 */
	this.attr = function(property, val){
	    if(typeof(val) != "undefined" && val != null) {
	        _self[property] = val;
	        			
			for (var n in _self._observers["onPropertyChange"]) {
			    _self._observers["onPropertyChange"][n]({property:property, val:val});
			}
			
	    } else {
	        return _self[property];
	    }
	} //attr
	
	/**
	 * Used to attach a listener to the given 'event'.
	 * When the specified 'event' occurs, the given callback will be invoked.
	 * The callback function will be parameterized with an Associative Array of values (if any).
	 * Current supported events: "onPropertyChange".
	 * @param {String} event. The event to observe.  Required.
	 * @param {Function} funct.  Function to be invoke upon 'event' triggering.  Required.
	 */
	this.addCallback = function(event, funct) {
	    
	    if(!event || typeof(event) != "string") {
	        return null;
	    } else if (!funct || typeof(funct) != "function") {
	        return null;
	    }
	    
	    if(typeof(_self._observers[event]) == "undefined") {
	        _self._observers[event] = new Array();
	    }
	    return (_self._observers[event].push(funct) - 1);
	} //addCallback
	
	/**
	 * Removes callback(s) from this Wms Layer object.
	 * If only an 'eventType' is provided, all observers of 'eventType' will be removed.
	 * If an 'id' is provided, only that observer of 'eventType' will be removed.
	 * The 'id' is just the index of the callback function (returned by .addCallback
	 * @params {String} eventType.  The name of the event.  Required.
	 * @params {Int} id.  The id (index) of the callback to remove.  Optional.
	 */
	this.removeCallback = function(eventType, id) {	    
	    if(!_self._observers[eventType]) return;
	    if( id ) id = parseInt(id);
	    if(!id) {
	        for(var i in _self._observers[eventType]) {
	            delete _self._observers[eventType][i];
	        }	    
	    } else {	    	            	    
	        if( id < 0 || id >= _self._observers[eventType].length) return;
	        delete _self._observers[eventType][id];
	    }	
	}
	
	
	/**
	 * Creates a [Dmp][Layer][ResourceReference] based on the parameters and adds it to this WmsLayer's ResourceReference list.
	 * Links this layer to a resource
	 * @see Dmp.Layer.ResourceReference
	 * @param {String} tagOrResourceReference.  A string to uniquely identify this ResourceReference or a Dmp.Layer.ResourceReference object.  Recommended.
	 * @param {String} resourceName.  Name of a Resource to bind to this WmsLayer.  First parameter will be used in place of resourceName is not provided.  Optional.
	 * @param {String} style.  A string/IStyle object of an SldPath/SldBody.  Will be overridden if 'style' is provided in the extra parameter.  Recommended.
	 * @param {Object} params.  Associative Array or xml dom of extra parameters to instantiate this ResourceReference.  Optional.	 
	 */	 	 
	this.addChild = function(tagOrResourceReference, resourceName, style, params) {
	            
        var res = null;
        
        //first parameter is a resourceReference object
        if(tagOrResourceReference && typeof(tagOrResourceReference) == "object" && 
            typeof(tagOrResourceReference.isVisible) == "function") {
        
            res = tagOrResourceReference;            
        } 
        //first parameter is an xmlDom is provided for a map composition load
        else if (tagOrResourceReference && typeof(tagOrResourceReference) == "object" && 
            typeof(tagOrResourceReference.getAttribute) != "undefined") {
            
            res = new Dmp.Layer.ResourceReference(tagOrResourceReference, _self.connectionId, {connectionUrl:_self.connectionUrl});             
        }
	    else { 
            
	        tagOrResourceReference = "" + tagOrResourceReference;	        
		    if (!resourceName) {
	            resourceName = tagOrResourceReference;
	        }	                	    		
	        if(tagOrResourceReference == "") tagOrResourceReference = "ResourceReference_" + Dmp.Util.getGuid();
    			        
            res = new Dmp.Layer.ResourceReference(resourceName, _self.connectionId, {connectionUrl:_self.connectionUrl}); 
            Dmp.Util._populateFromJson(res, params); //set parameter properties on the resourceReference
    		
            res.resourceName = resourceName;
            if(style) res.attr("style", style); //"style" MUST be set using .attr to function properly
	        
            if(!res.id) res.id = tagOrResourceReference;	
	    
        }
        				
		_self._resourceReferences.push(res); //add 'res' to Collection
		
	} //addChild
	
	/**
	 * Finds the first ResourceReference with matching ID and removes it.  Listeners are not removed.
	 * This method uses splice.
	 * @params {String} id.  The ID of the ResourceReference to match.
	 * @returns  the first ResourceReference with a matching ID
	 * @type {Dmp.Layer.ResourceReference}
	 */
	this.removeChildById = function(id) {	    
	    for(var i in _self._resourceReferences) {
	        if( _self._resourceReferences[i].id == id ) {
	            var res = _self._resourceReferences.splice(i, 1);
	            return res;
	        }
	    }
	    return null;	
	} //end removeChildById
	
	/**
	 * Returns a ResourceReference object associated with this WmsLayer that has a matching ID.
	 * In the event of multiple ResourceReference containing the same ID, the first one to be added will be the
	    first to return.
	 * @see Dmp.Layer.ResourceReference
	 * @params {String} id.  The string that uniquely identifies the ResourceReference.  Required.
	 * @returns  first ResourceReference with a matching ID
	 * @type {Dmp.Layer.ResourceReference}
	 */
	this.getChildById = function(id) {	    
		for(var i in _self._resourceReferences) {
			if (_self._resourceReferences[i].id == id) { return _self._resourceReferences[i]; }
		}
		return null;
	} //getChildById
	
	
	function firstLoad() {
		
		typeName = Dmp.Util.getGuid();
		var width = _self._map.getWidth();
		var height = _self._map.getHeight();
		
		_self._pushpin = new Microsoft.Maps.Pushpin(_self._map.getCenter(), {
			icon:"",
			width:width,
			height:height,
			anchor: new Microsoft.Maps.Point(width / 2, height / 2),
			typeName: typeName		
		
		});
		
		_self._map.entities.push(_self._pushpin);
		
		//var found = false;
		var list = _self._map.getRootElement().getElementsByTagName("a");
		for(var i = list.length - 1; i >= 0; i--) {
			if ( list[i].className.indexOf(typeName) >= 0) {
				_self.layerDiv = list[i];
				//found = true;
				break;
			}
		}
		//if(found) _self.refresh();
		_self.refresh();		
	} //firstLoad
	
	
	/**
	 * Adds this layer to the Bing Map.
	 * Adds a handle of itself to dmpLayers.  dmpLayers is a custom Collection on the Bing Maps object.
	 * Internally invoked by [MAP].addLayer.
	 * @see Microsoft.Maps.Map.prototype.dmpLayers
	 * @see Microsoft.Maps.Map.prototype.addEntity
	 * @param {Object} map. Bing Maps object that this WmsLayer should be added to.  Required.
	 * @private
	 */
	this._addEntity = function(map) {
		if( !(_self._map) ) _self._map = map;
		
		var listener = Microsoft.Maps.Events.addHandler(_self._map, "viewchangeend", onChangeView);
		_listeners.push(listener);

		_self._map.dmpLayers.push(_self);
		firstLoad();
		
		_listeners.push(Microsoft.Maps.Events.addHandler(_self._map, "viewchangestart", function (e) {
			//alert( _self._map.getZoom() + " -> " + _self._map.getTargetZoom() );
			//TODO: set zoomFlag
			if (_self._map.getZoom() != _self._map.getTargetZoom()) {
				_self._zoomFlag = true;
				_self._pushpin.setOptions({ visible: false });
			}
		}));

	} //_addEntity
				
	
	/**
	 * Removes this WmsLayer from the Bing Maps object and the custom collection: dmpLayers, and associated observers are removed.	 
	 * This method uses splice (array length will change after each remove)
	 * Called internally by [MAP].removeLayer
	 * @see Microsoft.Maps.Map.prototype.removeEntity
	 * @private
	 */
	this._removeEntity = function() {
	    				
		//remove from Dmp Map Layer list
		var index = 0;
		for (index; index < _self._map.dmpLayers.length; index++) {
		    if( !_self._map.dmpLayers[index] ) continue;
		    if(_self._map.dmpLayers[index].id == _self.id) { break; }
		}
		if(index >= _self._map.dmpLayers.length) { return; }		
		_self._map.dmpLayers.splice(index, 1);
        
        //remove Bing Maps entity object
        if( _self._pushpin && _self._map.entities.indexOf(_self._pushpin) >= 0) {
            _self._map.entities.remove(_self._pushpin);
        }
        
        //remove Bing Maps listeners						
		for(var n in _listeners) {
		    Microsoft.Maps.Events.removeHandler(_listeners[n]);
		}
		
		//remove custom listeners
		for(var n in _self._observers) {
		    delete _self._observers[n];
		}
	} //_removeEntity
	
	/**
     * Forces this WmsLayer to re-draw.
     * Internally invoked if [MAP].refresh() is called.
     * Should be invoked by the application upon Layer/ResourceReference updates.
	 */
	this.refresh = function() {
	    _self.draw();
	} //refresh

    

	/**
	 * Logic to improve overall display of the image when panning/zooming.
	 * Removes the old and adds the newly positioned and imaged Bing Maps pushpin object.
	 * @private
	 */
	this._imageLoaded = function() { 

		// Remove callback
        this.onload = null;

        //initialize variables.  Check that they exist.
        var source = this.src;
        var contextUrl = this.name;
        if (!source || typeof (source) != "string" || !contextUrl || typeof (contextUrl) != "string") return;

        //parse context string from imgTag div
        var bbox = contextUrl.substring(contextUrl.indexOf("bbox=") + 5);
        bbox = bbox.split("&")[0];
        if (bbox) bbox = bbox.split(",");
        if (!bbox || !bbox.length || bbox.length != 4) return;

        //Check to ensure that this is the last request that went out.
        //If a newer one is on it's way (or has already come back), hold off on setting the image tag.
        if (contextUrl != _self._lastRequest) return;

        if (!_self._map) return;

        //compare context string's bounding box with current map view
        var mapView = _self._map.getBounds();

        if (mapView.getSouth() == bbox[1] && mapView.getEast() == bbox[2] &&
            mapView.getNorth() == bbox[3] && mapView.getWest() == bbox[0]) {

            _self._pushpin.setLocation(_self._map.getCenter());
			if (_self._zoomFlag && _self.visibility) {
                _self._pushpin.setOptions({ visible: true });
            }
			
            if (!_self.layerDiv || !_self.layerDiv.parentNode) {
                
				var list = _self._map.getRootElement().getElementsByTagName("a");
				var found = false;
				for(var i = list.length - 1; i >= 0; i--) {
					if ( list[i].className.indexOf(typeName) >= 0) {
						_self.layerDiv = list[i];
						found = true;
						break;
					}
				}
                if (!found) return;

            }

            if (_self.zIndex) _self.layerDiv.style.zIndex = _self.zIndex;
            else _self.layerDiv.style.zIndex = 3;

            if (_self.opacity <= 1) {
                this.style.filter = "alpha(opacity=" + (_self.opacity * 100) + ")";
            }

            if (_self.layerDiv.lastChild) {
                var lastImageTag = _self.layerDiv.lastChild;
                _self.layerDiv.replaceChild(this, lastImageTag);
                lastImageTag.src = "http://maps.digitalmapcentral.com/images/1x1.png";
            }
            else _self.layerDiv.appendChild(this);

			_self._zoomFlag = false;
            _self._pushpin.setOptions({
                anchor: new Microsoft.Maps.Point(_self._map.getWidth() / 2, _self._map.getHeight() / 2),
                width: _self._map.getWidth(),
                height: _self._map.getHeight()
            });

        }
		
	} //_imageLoaded		

		
	/**
	 * Issues a re-draw when the map view changes.
	 * Attached via Bing Maps event 'viewchangeend'
	 * @private
	 */
	function onChangeView() {		    
		_self.draw();
	} //onChangeView
					
	/**
	 * Constructs a single GetMap request for all ResourceReferences associated with this WmsLayer.
	 * Uses properties on the WmsLayer and the ResourceReference to construct the request.
	 * Only ResourceReferences that are visible in the current state are added to the request.
	 * Internally invoked by panning/zooming events as well as refresh() calls.
     * Not recommended to be called by the application.  Use .refresh() instead.
	 */
	this.draw = function(){
	
	    if(typeof(_self._drawAddon) == "function") { 
	        _self._drawAddon(); 
	        return;
	    } 
	
		var layers = ""; //must
		var sld = ""; //optional
		var sldEmpty = true;
		var sldBody = null;
		var attributeLinks = ""; //optional
		var linksEmpty = true;
		var query = ""; //optional
		var queryEmpty = true;		
		var temporaryResource = ""; //for server/folder path of temporary resources
		var visibleRes = new Array();
	    
	    //generate: list of "visible" resourceReferences, SLDs + attributeLinks, queries, and temporary resources	        	        
		for(var i in _self._resourceReferences) {
			if( _self._resourceReferences[i].isVisible(_self._map) ) {
											
				var resourceName = (_self._resourceReferences[i].resourceName);
		        layers += "," + resourceName;
				
				var style = _self._resourceReferences[i].attr("style");
				if( style && typeof(style) == "object") {
				    if(style.getType() == "body") {
				        sldBody = style.getStyleValue();
				    }	    
					sld += "," + style.getStyleValue();
					sldEmpty = false;
				} else {
					sld += ", ";
				}
								
				//'attributeLink' check
				if(style && typeof(style) == "object" && style.getAttributeLink() ) {				
					attributeLinks += "," + style.getAttributeLink();
					linksEmpty = false;
				} else {
					attributeLinks += ",";
				}
				
				//'query' check
				if(_self._resourceReferences[i].filter) {
					query += "," + _self._resourceReferences[i].filter;
					queryEmpty = false;
				} else {
					query += ",";
				}
				
				if(resourceName && resourceName.match(/_T\d{1,3}/gi)){
    			    temporaryResource = resourceName;
			    }								
				
				//store visible resourceReferences
				visibleRes.push(_self._resourceReferences[i]);
			}
		}
		
		//remove the pushpin if no children are visible
        if (layers == "") {
            _self._pushpin.setOptions({ visible: false });
            _self._zoomFlag = false;

            if (_self.layerDiv && _self.layerDiv.lastChild) {
                var lastImageTag = _self.layerDiv.lastChild;
                var blankImg = document.createElement("img");
                blankImg.src = "http://maps.digitalmapcentral.com/images/1x1.png";
                _self.layerDiv.replaceChild(blankImg, lastImageTag);
                lastImageTag.src = "http://maps.digitalmapcentral.com/images/1x1.png";
            }

            for (var n in _self._observers["onDisplayComplete"]) {
                _self._observers["onDisplayComplete"][n]({ eventType: "onDisplayComplete", layer: _self });
            }

            return;
        }
        else if (_self.visibility && !_self._zoomFlag) {
            _self._pushpin.setOptions({ visible: true });
        } else if (!_self.visibility) {
            _self._pushpin.setOptions({ visible: false });
            if (_self.layerDiv && _self.layerDiv.lastChild) {
                var lastImageTag = _self.layerDiv.lastChild;
                var blankImg = document.createElement("img");
                blankImg.src = "http://maps.digitalmapcentral.com/images/1x1.png";
                _self.layerDiv.replaceChild(blankImg, lastImageTag);
                lastImageTag.src = "http://maps.digitalmapcentral.com/images/1x1.png";
            }
            _self._zoomFlag = false;
        } //end if/else//end if/else
		
		//generate bounding box information
		var params = Dmp.Util.getMapView(_self._map);
		
		var callbackWaiting = function() {
				    
		    var url = _self.connectionObj.getBaseUrl(temporaryResource) + "GetMap.aspx?"; 
		    		    		    		    
		    url += "bbox=" + params.xMin + "," + params.yMin + "," + params.xMax + "," + params.yMax;
		    url += "&width=" + _self._map.getWidth();
		    url += "&height=" + _self._map.getHeight();
		    url += "&layers=" + layers.substring(1); //remove extra first comma
		    if(!sldEmpty) { 
		        if(sldBody) { url += "&sld_body=" + sldBody; }
	            else { url += "&sld=" + sld.substring(1); }
	        }
		    if(!linksEmpty) url += "&attributeLinks=" + attributeLinks.substring(1); //URIEncode marker
		    if(!queryEmpty) url += "&query=" + query.substring(1); //URIEncode marker
		    if(visibleRes[0].viewInTime) url += "&viewInTime=" + visibleRes[0].viewInTime; //URIEncode marker
		    
		    		    
		    var _renderOptions = Dmp.Layer._checkRenderOptions(_self);
            for(var n in _renderOptions) {
                url += "&"+n+"=" + _renderOptions[n]; //URIEncode marker
            }

			var imgTag = document.createElement('img');
		    imgTag.onload = _self._imageLoaded;
		    
			//if (_self.zIndex) _self.layerDiv.style.zIndex = _self.zIndex;
			//else _self.layerDiv.style.zIndex = 3;
						
		    url = _self.connectionObj.finalizeUrl(url);
		    _self._lastRequest = url;
		    imgTag.name = url;  			
			imgTag.setAttribute("src", url);
												
		}
		if(_self.connectionObj.isReady()) { callbackWaiting(); }
		else { _self.connectionObj._loadArray.push(callbackWaiting); }
		
	} //draw   
	
	
	//check to load via XML.  Otherwise set the "id" of the layer.
	if(tagOrXml && typeof(tagOrXml) == "object" && typeof(tagOrXml.getAttribute) != "undefined" && typeof(_self._load) == "function") {
	    _self._load(tagOrXml);	
	} else {
	    this.id = "" + tagOrXml;
	}
	
	//copy the "params" parameters as properties on the layer
	if(params) {	    
	    Dmp.Util._populateFromJson(_self, params);	    
	    this.connectionUrl = params.connectionUrl;
	}
	
	//after everything is loaded, construct the proper connection object				
	this.connectionObj = Dmp.Env.Connections.getConnectionObject(this.connectionId, this.connectionUrl);
	
	
} //Dmp.Layer.WmsLayer

Dmp.Core.Layers.MapLayers.WmsLayer = Dmp.Layer.WmsLayer;
Dmp.Layer.WMSLayer = Dmp.Layer.WmsLayer
/**
 * CONFIDENTIAL AND PROPRIETARY
 * This document is confidential and contains proprietary information.
 * Neither this document nor any of the information contained herein
 * may be reproduced or disclosed to any person under any circumstances
 * without the express written consent of Digital Map Products.
 *
 * Copyright:    Copyright (c) 2011
 * Company:      Digital Map Products
 * @author       Gregory
 * @version      1.0
 *
 */

/**
 * @class
 * TileLayer class inherits from [Dmp][Layer][IMapLayer] and wraps the Bing Map Tilesource.
 * If a display property is changed, application must call [LAYER].refresh() or [MAP].refresh() for this layer to function properly
 * @extends {Dmp.Layer.IMapLayer}
 * @param {String} tagOrXml.  A string to uniquely identify this MapLayer or an Xml string definition of this layer.  Recommended.
 * @param {String} connectionId.  ID of the Connection object that this MapLayer belongs.  Required if a tag is provided.
 * @param {String} resourceName.  Name of the resource that binds this TileLayer.  If provided, a ResourceReference will automatically 
        be created for this layer.  Optional.
 * @param {Object} params.  An associative array of layer properties and render options.  Optional.
 *  To add render options, simply add the options to the json object as a normal parameter.
 *  The render options will be appended to the GetMap requests (only valid options will be appended).
 *  The render options that have values dependent on the number of ResourceReferences in the layer are NOT supported.  To use these,
    add them at the ResourceReference level.  
 */
Dmp.Layer.TileLayer = function(tagOrXml, connectionId, params) {

    if(!tagOrXml) {        
        tagOrXml = "TileLayer_" + Dmp.Util.getGuid();
        
    } else if( typeof(tagOrXml) != "object" && (!connectionId || (typeof(connectionId) != "string" && typeof(connectionId) != "number")) ) {
        //throw new Error("connectionId must be a non-empty string");
        //return;
    }
        
	this.base = Dmp.Layer.IMapLayer;
	this.base();	
	
	var _self = this;
	var _resourceReference = null;  //handle to the current resourceReference that this Map Layer is using
	var _tileLayer = null;  //handle top the Bing Maps Tile Layer object that this Map Layer is using
	var _isAdded = false;  //set to true when [MAP]._addEntity is invoked
	var _tileSource = null;
	
	this.getClassName = function() { return "TileLayer"; }	//used mainly for map composition save
	this.connectionId = "" + connectionId;
	this.isSerialized = true; //capable of being saved into a map composition
	
	this._observers = new Object(); //Bing Maps listeners
	this._listeners = new Array(); //custom event listeners
	
	 
	/**
	 * Creates a [Dmp][Layer][ResourceReference] or TileSource based on the parameters and adds it to this TileLayer's ResourceReference list.
	 * Internally invoked upon initialization if the expected parameters are instantiated.
	 * TileLayers only use 1 ResourceReference. If multiple ResourceReferences are added, only the last one added will be used.
     * Links this MapLayer to a ResourceReference.
	 * @see Dmp.Layer.ResourceReference
	 * @param {String} tagOrResourceReference.  A string to uniquely identify this ResourceReference or a Dmp.Layer.ResourceReference object.  Recommended.
	 * @param {String} resourceName.  Name of a Resource to bind to this TileLayer.  First parameter will be used in place of resourceName is not provided.  Optional.
	 * @param {String} style.  A string/IStyle object of an SldPath/SldBody.  Will be overridden if 'style' is provided in the extra parameter.  Recommended.
	 * @param {Object} params.  Associative Array or xml dom of extra parameters to instantiate this ResourceReference.  Optional.	 
	 */	 
    this.addChild = function(tagOrResourceReference, resourceName, style, params) { 
	    	    	    	    
        var res = null;
        
	    //first parameter is a resourceReference object
        if(tagOrResourceReference && typeof(tagOrResourceReference) == "object" && 
                typeof(tagOrResourceReference.isVisible) == "function" ) {
                      
            res = tagOrResourceReference;
        }        
        //first parameter is XML dom
        else if (tagOrResourceReference && typeof(tagOrResourceReference) == "object" && 
            typeof(tagOrResourceReference.getAttribute) != "undefined") {
            res = new Dmp.Layer.ResourceReference(tagOrResourceReference, _self.connectionId, {connectionUrl:_self.connectionUrl});
        } 
        else {
	        tagOrResourceReference = "" + tagOrResourceReference;	        
		    if (!resourceName) {
	            resourceName = tagOrResourceReference;
	        }	                	    		
	        if(tagOrResourceReference == "") tagOrResourceReference = "ResourceReference_" + Dmp.Util.getGuid();    		
    	    	        
            res = new Dmp.Layer.ResourceReference(resourceName, _self.connectionId, {connectionUrl:_self.connectionUrl});
            Dmp.Util._populateFromJson(res, params);  //set parameter properties on the resourceReference
            res.resourceName = resourceName;	        	        
    	    
    	    if(style) res.attr("style", style);  //"style" MUST be set using .attr to function properly
	        if(!res.id) res.id = tagOrResourceReference;
	        
	    }
	    _resourceReference = res;
	    _self._resourceReferences.push(_resourceReference);	    
	    _self.connectionObj = _resourceReference.connectionObj;
	    
	} //addChild	
	
	
	/**
	 * Finds the first ResourceReference with matching ID and removes it.  Listeners are not removed.
	 * @params {String} id.  The ID of the ResourceReference to match.
	 * @returns  the first ResourceReference with a matching ID
	 * @type {Dmp.Layer.ResourceReference}
	 */
	this.removeChildById = function(id) {	    
	    for(var i in _self._resourceReferences) {	        
	        if( _self._resourceReferences[i].id == id ) {
	            var res = _self._resourceReferences.splice(i, 1);
	            if( res && res[0] == _resourceReference ) {
	                _resourceReference = null;
	                for(var n in _self._resourceReferences) { 
	                    _resourceReference = _self._resourceReferences[n];
	                }
	            }
	            return res;
	        }
	    }
	    return null;	
	} //end removeChildById
	
	
	/**
	 * Returns a ResourceReference object associated with this TileLayer that has a matching ID.
	 * In the event of multiple ResourceReference containing the same ID, the first one to be added will be the
	    first to return.
	 * @see Dmp.Layer.ResourceReference
	 * @params {String} id.  The string that uniquely identifies the ResourceReference.  Required.
	 * @returns  first ResourceReference with a matching ID
	 * @type {Dmp.Layer.ResourceReference}
	 */
	this.getChildById = function(id) {	    
		for(var i in _self._resourceReferences) {		    
			if (_self._resourceReferences[i].id == id) { return _self._resourceReferences[i]; }
		}
		return null;
	} //getChildById
	
	
	/**
	 * Adds the TileLayer to the Bing Maps entity collection.
	 * Adds a handle of itself to dmpLayers.  dmpLayers is a custom Collection on the Bing Map object.	 
	 * Internally invoked by [MAP].addEntity.
	 * @see Microsoft.Maps.Map.prototype.dmpLayers
	 * @see Microsoft.Maps.Map.prototype.addEntity
	 * @param {Object} map.  Bing Map object that this TileLayer should be added to.  Required.
	 * @private
	 */
	this._addEntity = function(map) {
							
		if( !(_self._map) ) _self._map = map;
		
		//must wait until connection object establishes
		var callbackWaiting = function() {
		    _self.connectionObj = _resourceReference.connectionObj;				    		     		                                
            _isAdded = true;
            _self._map.dmpLayers.push(_self);
            
            var listener = Microsoft.Maps.Events.addHandler(_self._map, "viewchangestart", handleZoom);
            _self._listeners.push(listener);
			
			_tileLayer = _self.draw(); //entity is added to map in .draw() method														
		}		
		if( !_self.connectionObj || _self.connectionObj.isReady()) { callbackWaiting(); }
		else { _self.connectionObj._loadArray.push(callbackWaiting); }
		
		
	} //_addEntity
	
	/**
	 * Allows for zoom limits to be respected.
	 * Trigger: viewchangestart
	 * @private
	 */
	function handleZoom() {
	//debugger;
	    if(!_resourceReference || !_resourceReference.zoomRange) return;	
	    var zoom = _self._map.getTargetZoom();	 	       
	    if (!_resourceReference.visibilityPreference || zoom < _resourceReference.zoomRange.min || zoom > _resourceReference.zoomRange.max) {	    
	        if( _tileLayer && _self._map.entities.indexOf(_tileLayer) >= 0 ) {
                _self._map.entities.remove(_tileLayer);
            }            
	    } else {
            if(_tileLayer && _self._map.entities.indexOf(_tileLayer) < 0 ) {            
                _self._map.entities.push(_tileLayer);
            }            
	    }
	} //handleZoom
	
	
	/**
	 * Removes this TileLayer from the Bing Maps entity collection and the custom collection: dmpLayers.
	 * This method uses splice (array length will change after each remove)
	 * Called internally by [MAP].removeEntity
	 * @see Microsoft.Maps.Map.prototype.removeEntity
	 * @private
	 */
    this._removeEntity = function() {
        var _self = this;	
	    var index = 0;
	    var layers = this._map.dmpLayers;
	    
	    //locate index in Dmp Map Layer collection
	    for (index; index < layers.length; index++) {
	        if( !layers[index] ) continue;
	        if(layers[index].id == _self.id) { break; }
	    }	    

        //remove from Bing Maps entity collection
        if( _tileLayer && _self._map.entities.indexOf(_tileLayer) >= 0) {
            _self._map.entities.remove(_tileLayer);
        }
        
        //remove Bing listeners
        for( var n in _self._listeners) {
            Microsoft.Maps.Events.removeHandler( _self._listeners[n] );
        }
        
        
        //remove from Dmp Map Layer collection
        if(index >= layers.length) { return; }
	    this._map.dmpLayers.splice(index, 1);
	    
    } //_removeEntity
	
	 /**
	 * Accessor/Mutator method for all properties on this object.
	 * Sets 'property' if 'val' is provided, returns 'property' otherwise.
	 * If a display property is changed, [LAYER].refresh MUST be invoked for a proper update of the layer.
	 * @param {String} property.  A string matching the name of a property on this object.  Required.
	 * @param {Object} val.  An object matching the type of this[property].  Optional.
	 * @returns  The value of the given property if 'val' is not provided.  Returns null otherwise.
	 * @type {Object}
	 */
	this.attr = function(property, val){
		if(typeof(val) != "undefined") {
			_self[property] = val;
		} else {
			return _self[property]
		}
	} //attr
	
	 
	/**
	 * Returns the handle to the currently active ResourceReference, which links this layer to a resource
	 * @returns the ResourceReference of this layer
	 * @type {Dmp.Layer.ResourceReference}
	 */
	this.getResourceReference = function() {
	    return _resourceReference;
	} 
	 
	/**
	 * Uses properties on this TileLayer to construct tile requests if the layer is visible.
	 * Internally invoked by refresh() calls.
	 * @private
	 */
	this.draw = function() {
		
		var _tempTileLayer = _tileLayer;
				  		
		var callbackWaiting = function() {
	         
	         
	         if(_tileSource == null) {                        
		        if( typeof(_resourceReference.getType) == "undefined" ) {    		        		        
		            _tileSource = new Dmp.Layer.DefaultTileSource(_resourceReference, {_renderOptions:_self._renderOptions});
		            _tileSource._map = _self._map;
		        }
		        else {
		            _tileSource = _resourceReference;
		        }
		    }
		    
		    /*
		    if( _tileSource ) {
		        var id = _tileSource.draw();
		        if(_self._map.GetTileLayerByID(id)) _self._map.DeleteTileLayer(id);
		        _self._map.AddTileLayer(_tileSource, visible);
		    }
		    */
		    
		    
		    if(_isAdded) {
		        _tempTileLayer = _tileSource.draw();
            }
                        
            
            /*
            
            if( _isAdded && _tileLayer && _self._map.entities.indexOf(_tileLayer) >= 0 ) {
                _self._map.entities.remove(_tileLayer);                            
            }            
            _tileLayer = _tileLayer.draw();
            if( _isAdded && _tileLayer && _self._map.entities.indexOf(_tileLayer) < 0 ) {
                _self._map.entities.push(_tileLayer);
            }
            */
                                   
		}
		if( !_self.connectionObj || _self.connectionObj.isReady()) { callbackWaiting(); }
		else { _self.connectionObj._loadArray.push(callbackWaiting); }
					
	    return _tempTileLayer;
	    
	} //draw
	
	/**
	 * Forces this TileLayer to re-draw.
	 * Internally invoked if VEMap.refresh() is called.	 
	 * Must be manually invoked after a property is changed to maintain correct layer behavior
	 */
	this.refresh = function() {
	    if( _tileLayer && _self._map.entities.indexOf(_tileLayer) >= 0 ) {
            _self._map.entities.remove(_tileLayer);                            
        } 
	    _tileLayer = _self.draw();
	}	
					
	if(tagOrXml && typeof(tagOrXml) == "object" && typeof(tagOrXml.getAttribute) != "undefined" && typeof(_self._load) == "function") {
	    _self._load(tagOrXml);
	} else {
	    this.id = "" + tagOrXml;
	}
	
	//use the "params" parameter to set the corresponding properties on this layer
	if(params) {
	    this._params = params;
	    this._renderOptions = Dmp.Layer._checkRenderOptions(params);
	    Dmp.Util._populateFromJson(_self, params);	    
	    this.connectionUrl = params.connectionUrl;
	}

	this.connectionObj = Dmp.Env.Connections.getConnectionObject(_self.connectionId, _self.connectionUrl);

	
} //Dmp.Layer.TileLayer


Dmp.Core.Layers.MapLayers.TileLayer = Dmp.Layer.TileLayer;


Dmp.Layer.DefaultTileSource = function(resourceReference, params) {

    var _self = this;
    var _tempTileLayer = null;
    
    this.draw = function() {
        
        
    
        var url = resourceReference.connectionObj.getBaseUrl(resourceReference.resourceName);
        url += "GetMap.aspx?layers=" + resourceReference.resourceName + "&tileId={quadkey}";
        
        //append "render options".  See Dmp.Layer._checkRenderOptions for more details
        var _renderOptions = Dmp.Layer._checkRenderOptions(params);
        if( _renderOptions ) {
            for(var n in _renderOptions) {
                url += "&"+n+"=" + _renderOptions[n]; //URIEncode marker
            }
        }
    	
	    //append "SLD"
        var style = resourceReference.attr("style")
        if(style && typeof(style) == "object" ) {
            if( style.getType() == "body" ) {
                url += "&sld_Body" + style.getStyleValue(); //URIEncode marker
            } else {
                url += "&sld=" + style.getStyleValue(); //URIEncode marker
            }
        }
        
        //append "attributeLinks"
        if(style && typeof(style) == "object" && style.getAttributeLink() ) {
            url += "&attributeLinks=" + style.getAttributeLink();
        }
        
        //append "query"
        if(resourceReference.attr("filter") && typeof(resourceReference.attr("filter")) == "string") {
            url += "&query=" + resourceReference.attr("filter"); //URIEncode marker
        }
        
        //append "viewInTime"
        if(resourceReference.attr("time") && typeof(resourceReference.attr("time")) == "string") {
            url += "&viewInTime=" + resourceReference.attr("time"); //URIEncode marker
        }
    			                		    
        //generate a new Bing Tile Layer and Bing Tile Source
        var tileSource = new Microsoft.Maps.TileSource({uriConstructor:resourceReference.connectionObj.finalizeUrl(url)});		    
        var obj = new Object();
        obj.mercator = tileSource;
        obj.zIndex = resourceReference.zIndex;
        obj.opacity = resourceReference.opacity;
          
        
       
                   
        _tempTileLayer = new Microsoft.Maps.TileLayer( obj );
        
        
        if( !resourceReference.isVisible(_self._map) ) {
            return _tempTileLayer;
        }
        
        if( _tempTileLayer && _self._map.entities.indexOf(_tempTileLayer) < 0 ) {
            _self._map.entities.push(_tempTileLayer);
        }
        
        
        return _tempTileLayer;
    }
    
}


if(typeof(Dmp.Env.Connections) == "undefined") {
    
    /**
     * Collection of Connection objects
     * Associative Array
     * @see Dmp.Conn.Connection
     */
    Dmp.Env.Connections = new Object();
    

} //end if

/**
 * Method for obtaining connection objects in modified forms.
 * Standard form:  Only 'source' is provided and is an ID to the connection object. The connection object is
    returned with no modifications.
 * New Domain form:  Only 'source' is provided and is a domain URL.  The connection object returned only has 
    static properties and the domain used will be 'source'.
 * Override Domain form:  Both 'source' and 'connectionUrl' are provided.  'source' is a valid ID and 'connectionUrl' is
    a domain URL.  The connection object returned has properties of the connectionObject[ID] but uses 'connectionUrl' as
    its domain URL when making requests.
 * You must include the "Utility" package when using the "source" parameter for a URL override.
 * URLs must be of the form "http://..../" or "https://..../"
 * @params {String} source.  ID for the connection object or a domain URL.  Required.
 * @params {String} connectionUrl.  A URL override for the connection object. Optional.
 * @returns a connection object (may be modified depending on parameters)
 * @type {Dmp.Conn.Connection}
 */
Dmp.Env.Connections.getConnectionObject = function(source, connectionUrl){

    var _self = this;
    var returnUrl = "";
    
    /**
     * Method that provides an overridden base url method for this connection object wrapper.
     * @param {String} newBaseUrl.  The new Url to be used in place of the original base.  Required.
     * @param {String} res.  The name of the resource that will be used in the following request.
        Allows proper server request when dealing with temporary layers.  Optional.
     * @private
     */
    function overrideBaseUrl(newBaseUrl, res) {
        if(!newBaseUrl || typeof(newBaseUrl) != "string" || newBaseUrl.length <= 0) return "";
        if(typeof(res) != "undefined" && res) {
            var tempPath = res.split("/")[0];
            if(tempPath && tempPath.match(/_T\d{1,3}/gi)){
                return "" + newBaseUrl + "/" + tempPath + "/";
            }
        }
        if(newBaseUrl.charAt(newBaseUrl.length-1) != "/") newBaseUrl += "/";
        return newBaseUrl;
    }
    
    //source is a valid connection ID
    if( source.indexOf("http://") == -1 && source.indexOf("https://") == -1 ) {
        
        if(!connectionUrl) {            
            return Dmp.Env.Connections[source];            
        } 
        else if (connectionUrl && typeof(connectionUrl) == "string") {
            if(connectionUrl.indexOf("http://") >= 0 || connectionUrl.indexOf("https://") >= 0) {
                    
                var obj = new function() {
                    var id = source; 
                    var _self = this;                           
                    for(var n in Dmp.Env.Connections[source]) {
                        this[n] = Dmp.Env.Connections[source][n];
                    }                            
                    this.getBaseUrl = function(res) {
                        return overrideBaseUrl(connectionUrl, res);
                    }
                    this.getJson = function(url, succ, err, output) {
                    
                        var domainedUrl = "";
	                    if( url.indexOf("http://") == -1 && url.indexOf("https://") == -1 ) {
		                    domainedUrl += this.getBaseUrl();
	                    }
	                    domainedUrl += url;		                    
	                    Dmp.Env.Connections[id].getJson(domainedUrl, succ, err, output);		                    
                    }
                    this.finalizeUrl = function(url) {
                        var newUrl = "" + url;
                        if( _self.useCandy && url.toUpperCase().indexOf("&SS_CANDY") < 0 ) {
                            newUrl += "&SS_CANDY=" + _self._candy;
                        }
                        if( _self.userId ) {
                            newUrl += "&uid=" + _self.userId;
                        }
                        return newUrl;
                    }                            
                }                            
                return obj;
            }
        }
    } 
    else {//if(source.indexOf("http://") != -1 || source.indexOf("https://") != -1){ //source is a url
        var obj = new function() {
            var closureSource = source;
            var _transactionClient = null;
            
            this.getBaseUrl = function(res) {
                return overrideBaseUrl(closureSource, res);
            }
            this.getJson = function(url, succ, err, output){                        
                var domainedUrl = "";
                if(url.indexOf("http://") == -1 && url.indexOf("https://") == -1) {
	                domainedUrl += this.getBaseUrl();
                }
                domainedUrl += url;
                Dmp.Util.getJson(domainedUrl, succ, err, output);
            }
            this.isReady = function() { return true; }
            this.finalizeUrl = function(url) { return url; }
            
            /*
            //TODO: possible?
            this.getTransactionClient = function() { return _transactionClient; }
            if (Dmp && Dmp.TransactionClient) {
                _transactionClient = new Dmp.TransactionClient(obj);
            }
            */
        }
        return obj;                
    } //end if/else
} //end Dmp.Env.Conn



/**
 * Collection of Resource objects that are internally created when a ResourceReference or Resource object is constructed.
 * @see Dmp.Layer.Resource
 * @see Dmp.Layer.ResourceReference
 */
Dmp.Env.Resources = new Object();

/**
 * @class
 * Connection object that handles the proper workflow for sending authenticated web requests.
 * @param {String} initUrl.  Initialization URL to start this session. Typically is "initSession.aspx".  Recommended.
 */
Dmp.Conn.Connection = function(initUrl) {

    if(typeof(initUrl) == "undefined" || !initUrl) {
        //throw new Error("Session URL must be present");
    }
    
	var _self = this;
	var _initComplete = false;
	
	//extract the base url  (http://parcelstream.com/InitSession.aspx -> http://parcelstream.com)
	//_baseUrl will be reset after .init(sik) is called
	var _baseUrl = ""; 
	var _initService = "";
	
	
	var parseHelper = initUrl.split("://");
	if(parseHelper.length >= 2) { 
		_baseUrl += parseHelper[0] + "://"
		parseHelper = parseHelper[1].split("/");
	} else {
		_baseUrl += "http://"
		parseHelper = parseHelper.split("/");
	}
	_baseUrl += parseHelper[0]; 	// http://parcelstream.com
	_initService += parseHelper[1]; // InitSession.aspx  
	
	this.userId = null;
	this.useCandy = false;	
	this._loadArray = new Array(); // used for methods needing 'onload' callbacks
	var _domainList = new Array();
	
	
	var _transactionClient = null;
	if(Dmp && Dmp.TransactionClient) _transactionClient = new Dmp.TransactionClient(this);
	
	this.getTransactionClient = function() {
	    return _transactionClient;
	}
	
	this.setTransactionClient = function(tc) {
	    _transactionClient = tc;
	}
	
		
	/**
	 * Handles web requests asynchronously.
	 * Supports full url (http://spatialstream.com/getQuery.aspx?...) or service only (getQuery.aspx?...) 
	 * @param {String} jsonUrl
	 * @param {Function} succCall
	 * @param {Function} errCall
	 * @param {String} outputType
	 */
	this.getJson = function(jsonUrl, succCall, errCall, outputType) {     
		return getJsonInternal(jsonUrl, succCall, errCall, outputType);
	} //getJson
	
	function getJsonInternal(jsonUrl, succCall, errCall, outputType, init)
	{
	    var MAX_WAIT_TIME = 2 * 1000;
		var timeoutThread = null;
		var callbackFunc = Dmp.Util.getGuid();
		var sucCallback = "S" + callbackFunc;
		var errCallback = "E" + callbackFunc;

		//Listener for script loader
		function _loadedURL() {
			if (timeoutThread == "done") return;

			//in case we got called multiple times, cancel the previous threads.
			if (timeoutThread) window.clearTimeout(timeoutThread);

			//start the timer.
			timeoutThread = window.setTimeout(function() {
				//Timeout error
				if (errCall) {
					var resp = { Response: { Error: { message: "Timeout"}} };
					errCall(resp);
				}
			}, MAX_WAIT_TIME);

		} //_loadedURL


		function _clean() {
			if (timeoutThread) window.clearTimeout(timeoutThread);
			else timeoutThread = "done";
			window[sucCallback] = null;
			window[errCallback] = null;
		}; //_clean

		//On Success
		window[sucCallback] = function(p1, p2, p3, p4) {
			_clean();
			if (succCall) succCall(p1, p2, p3, p4);
		}; //succ

		//On Error
		window[errCallback] = function(p1, p2, p3, p4) {
			_clean();
			if (errCall) errCall(p1, p2, p3, p4);
		}; //err
    
        var callbackWaiting = function() {
		    var urlWithOid = "";
		    if( jsonUrl.indexOf("http://") == -1 && jsonUrl.indexOf("https://") == -1 ) {
			    urlWithOid += _self.getBaseUrl();
		    }
		    urlWithOid += jsonUrl;

		    if (jsonUrl.indexOf("?") > 0) urlWithOid += "&";
		    else urlWithOid += "?";

		    urlWithOid += "obsId=window";
		    urlWithOid += "&obsSuccessMethod=" + sucCallback;
		    urlWithOid += "&obsErrorMethod=" + errCallback;

		    if (urlWithOid.indexOf("output=") < 0) {
			    if (!outputType) outputType = "json";
			    urlWithOid += "&output=" + outputType;
		    }

            if( init != "init" ) {
		        urlWithOid = _self.finalizeUrl(urlWithOid);
		    }
		
		    //'using' Call					
			using("url(" + urlWithOid + ")", _loadedURL);
		}
		//secret parameter to stop all web requests until connection establishes (except the connection initializer)
		if(_self.isReady() || init == "init") { callbackWaiting(); }
		else { _self._loadArray.push(callbackWaiting); }
	}
	
	/**
	 * Returns the baseUrl of this connection object.  Optional 'res' parameter that accepts a temporary
	    * resource and appends the folder to the base url.
	 * @param {String} res.  Resource that will be used in the URL.  If it's temporary, the proper temporary information
	    * will be included in the baseUrl.  Optional.
	 * @returns base url of this connection
	 * @type {String}
	 */
	this.getBaseUrl = function(res) {
	    if(res && typeof(res) == "string") {
	        var tempPath = res.split("/")[0];
	        if(tempPath && tempPath.match(/_T\d{1,3}/gi)){
	            return "" + _baseUrl + "/" + tempPath + "/";
	        }
	    }
		return _baseUrl + "/";
	} //getBaseUrl


    /**
     * Appends any necessary authentication parameters to a URL string.
     * Should be used if a web request is not being sent through the connection object (i.e.  image tag src)
     * @param {String} url.  Required.
     * @returns  the URL with the necessary authentication parameters appended.
     * @type {String}
     */
    this.finalizeUrl = function( url ) {
        var newUrl = "" + url;
        
        //append candy if applicable
        if( _self.useCandy && url.toUpperCase().indexOf("&SS_CANDY=") < 0 ) {
            newUrl += "&SS_CANDY=" + encodeURIComponent( _self._candy );
        }
        
        //append userId if applicable        
        if( _self.userId && newUrl.toLowerCase().indexOf("&uid=") < 0) {
            newUrl += "&uid=" + _self.userId;
        }
        
        //append activeVersionId if applicable
        if( _transactionClient && _transactionClient.hasActiveVersion && _transactionClient.hasActiveVersion() &&
            newUrl.toLowerCase().indexOf("&activeversionid=") < 0) {
            newUrl += "&activeVersionId=" + _transactionClient.getVersionId();
        }
        
        return newUrl;
    }

    /**
     * @returns the service used for initSession
     * @type {String}
     * @private
     */
	this._getInitService = function() {
		return _initService;
	}
	
	/**
	 * Determins if the InitSession aspx call for this connection object has been completed.
	 * @returns true if the initialization calls are complete
	 * @type {Boolean}
	 */
	this.isReady = function() {
	    return _initComplete;
	}
	

	
	/**
	 * Begins initialization of this connection object, which in mose cases is calling InitSession aspx and UserProperties aspx.
	 * The alternative case is authenticating a page using the same cookie.
	 * optionalCallback should be used if any authenticating-required web requests are made by the application on startup
	 * The asynchronous workflow is handled for internal web requests 
	 * @param {String} sik.  Of the form "KEY" or "/sub-domain/folder/KEY".  Recommended.
	 * @param {Function} optionalCallback.  Function to be invoked upon authentication completion.  Optional.
	 */
	this.init = function(sik, optionalCallback){
		
		if(typeof(sik) == "undefined" || !sik) {
		    //throw new Error("a SIK must be provided");
		}
				
		
		var key = sik;
		var _url = "";
		
		var urlParser = _self.getBaseUrl().split("://");
		if(urlParser.length >= 2) { _url += urlParser[0] + "://"; }
		urlParser = urlParser[1].split("/");
		
		if(key.charAt(0) == "/") { //parse
			var keyParser = key.split("/");
			
			//append sub-domain
			if(keyParser[1] != "") { _url += keyParser[1] + "."; }
			
			//append domain
			_url += urlParser[0];
			
			//append post-domain
			_url += "/" + keyParser[2];
			
			//set key (sik)
			key = keyParser[2] + "/" + keyParser[3]; //URIEncode Marker
		} else {
			_url = _self.getBaseUrl();
		}
		
		if(_url.charAt(_url.length-1) == "/") _url = _url.substring(0, _url.length-1);
		_url += "/" + _self._getInitService() + "?sik=" + key;
		
		//'init' is a special key to allow web requests without completing the authentication process
		//callback also invokes UserProperties.aspx to handle browser cookies
		getJsonInternal(_url, function (response) {
		    var row = response.Response.Results.Data.Row;
		    _self.userId = row.UserId;
		    _self._candy = row.Candy;
		    _self.sessionId = row.SessionId;
		    _baseUrl = row.Domains.split(",")[0];
		    _domainList = row.Domains.split(",");
		    if(_baseUrl.charAt(_baseUrl.length-1) == "/") _baseUrl = _baseUrl.substring(0, _baseUrl.length-1);
			
		    //invoked after UserProperties.aspx logic is completed
		    function afterUserPropertyComplete() {
		        // callback queue for methods awaiting InitSession.aspx response
		        _initComplete = true;
		        while (_self._loadArray.length > 0) {
			        _self._loadArray[0]();
			        _self._loadArray.splice(0, 1);
		        }			    			
		        if(optionalCallback != null && typeof(optionalCallback) == "function") { optionalCallback(); }
		    }
			
			
		    //'init' is a special key to allow web requests without completing the authentication process
	        var testAuthenticationUrl = _self.getBaseUrl() + "UserProperties.aspx?";
	        getJsonInternal(testAuthenticationUrl, function(json) {		        
	            if ( json.User.authenticationMethod.toLowerCase() == "trustedreferrer" ) {
	                _self.useCandy = true;
	            }
	            afterUserPropertyComplete();
		        
	        }, function(err) {
	            //error		        
	            if(err && err.Response && err.Response.Error && err.Response.Error.message &&
	                err.Response.Error.message.indexOf("You are not logged in") >= 0) {
	                    _self.useCandy = true;		               
	            }
	            afterUserPropertyComplete();
		            
	        }, null, "init");

	    }, function (err) {
		//exception
	    }, null, "init");
	} //init
} //Dmp.Conn.Connection

if (typeof(Dmp.Env) == 'undefined') Dmp.Env = new Object();
if (typeof(Dmp.Env.Connections) == 'undefined') Dmp.Env.Connections = new Object();
Dmp.Env.Connections["SS"] = new Dmp.Conn.Connection("http://parcelstream.com/InitSession.aspx", ["t0", "t1", "t2", "t3"]);
